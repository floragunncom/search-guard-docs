#!/usr/bin/env python3
"""
sgconfig.py - surgical CLI editor for the Jekyll _config.yml used by the
Search Guard docs site.

It edits ONLY the keys you ask it to and leaves the rest of the file
byte-for-byte untouched (no YAML re-serialisation, so comments, blank lines,
quoting and alignment are preserved).

Supported targets
------------------
Scalar keys (single value):
    elasticsearch.minorversion
    elasticsearch.currentversion
    elasticsearch.currentversionlastmajor
    searchguard.version
    searchguard.islatestversion
    searchguard.currentversion
    searchguard.releasedate
    encryptionatrest.currentversion
    encryptionatrest.currentversionelasticsearch
    encryptionatrest.releasedate
    tlstool
    sgctl

List channels under sgversions (pipe-delimited ordered rows):
    search-guard-flx-9   cols: esv|sgv|kbv|available|eol|kubernetes|helm|release-date
    search-guard-flx-8   cols: esv|sgv|kbv|available|eol|kubernetes|helm|release-date
    search-guard-encryption-at-rest   cols: esv|sgv|available|eol|release-date

Usage examples
--------------
  # THE COMMON CASE: publish a new Search Guard FLX release.
  # Adds a row to search-guard-flx-<major> (kbv defaults to sgv, helm to
  # <sgv>-flx, release-date to today) AND to search-guard-encryption-at-rest,
  # runs the eol magic on both, and updates the version pointers:
  #   current-major (e.g. 9.x): elasticsearch.minorversion/currentversion,
  #       searchguard.currentversion + releasedate,
  #       encryptionatrest.currentversionelasticsearch + releasedate
  #       (and encryptionatrest.currentversion if --ear-sgv is given)
  #   last-major (e.g. 8.x): only elasticsearch.currentversionlastmajor
  # A release is identified by (esv, sgv): the same esv may be re-spun under a
  # new sgv (e.g. 9.4.3 gets both 4.1.2 and 4.1.3). That adds a new flx row
  # (higher sgv on top) and updates searchguard.currentversion; the EAR row is
  # skipped when that esv is already covered by the same EAR version. Exits
  # non-zero only on an exact (esv, sgv) duplicate (nothing written).
  ./sgconfig.py new-release --esv 9.4.3 --sgv 4.2.0     # current-major (9.x)
  ./sgconfig.py new-release --esv 8.19.20 --sgv 4.3.0   # last-major (8.x)
  ./sgconfig.py new-release --esv 9.4.3 --sgv 4.2.0 --release-date 2026-08-01

  # scalar sets (quoting of the existing value is preserved)
  ./sgconfig.py set elasticsearch.currentversion 9.4.3
  ./sgconfig.py set searchguard.currentversion 4.1.3
  ./sgconfig.py set tlstool 4.1.0
  ./sgconfig.py set searchguard.islatestversion true

  # add a new version row. Any column you don't pass is copied from the
  # newest existing row of the SAME major line. eol is managed automatically.
  ./sgconfig.py add flx-9 --esv 9.4.3
  ./sgconfig.py add flx-9 --esv 9.5.0 --sgv 4.2.0 --kbv 4.2.0
  ./sgconfig.py add ear   --esv 9.4.3

  # modify an existing row (match by esv), changing only the columns you pass
  ./sgconfig.py modify flx-9 9.4.2 --sgv 4.1.3 --helm 4.1.3-flx
  ./sgconfig.py modify ear 9.3.6 --eol yes

  # inspect
  ./sgconfig.py show flx-9

EOL rule (add)
--------------
Rows carry an `eol` (end-of-life) column. When you add a row:
  * new minor  > highest existing minor in that major line  -> the new row is
    eol=no and every older row IN THE SAME MAJOR line is flipped to eol=yes.
  * new minor == highest existing minor                     -> new row eol=no,
    older rows untouched.
  * new minor  < highest existing minor                     -> new row eol=yes.
"minor" is the middle number b of the semver esv a.b.c. Scope defaults to the
same major (a); pass --eol-scope all to flip across majors, or --eol yes|no to
force the new row's own value.
"""

import argparse
import datetime
import re
import shutil
import sys


def today_iso():
    return datetime.date.today().isoformat()

# ---------------------------------------------------------------------------
# Channel definitions
# ---------------------------------------------------------------------------
CHANNELS = {
    "search-guard-flx-9": {
        "cols": ["esv", "sgv", "kbv", "available", "eol", "kubernetes", "helm",
                 "release-date"],
        "eol": "eol",
    },
    "search-guard-flx-8": {
        "cols": ["esv", "sgv", "kbv", "available", "eol", "kubernetes", "helm",
                 "release-date"],
        "eol": "eol",
    },
    "search-guard-encryption-at-rest": {
        "cols": ["esv", "sgv", "available", "eol", "release-date"],
        "eol": "eol",
    },
}

# convenient short aliases -> canonical channel key
CHANNEL_ALIASES = {
    "flx-9": "search-guard-flx-9",
    "flx9": "search-guard-flx-9",
    "9": "search-guard-flx-9",
    "flx-8": "search-guard-flx-8",
    "flx8": "search-guard-flx-8",
    "8": "search-guard-flx-8",
    "ear": "search-guard-encryption-at-rest",
    "encryption-at-rest": "search-guard-encryption-at-rest",
}

# scalar keys of interest.  value = (top_level_block, subkey or None)
SCALAR_KEYS = {
    "elasticsearch.minorversion": ("elasticsearch", "minorversion"),
    "elasticsearch.currentversion": ("elasticsearch", "currentversion"),
    "elasticsearch.currentversionlastmajor": ("elasticsearch", "currentversionlastmajor"),
    "searchguard.version": ("searchguard", "version"),
    "searchguard.islatestversion": ("searchguard", "islatestversion"),
    "searchguard.currentversion": ("searchguard", "currentversion"),
    "searchguard.releasedate": ("searchguard", "releasedate"),
    "encryptionatrest.currentversion": ("encryptionatrest", "currentversion"),
    "encryptionatrest.currentversionelasticsearch":
        ("encryptionatrest", "currentversionelasticsearch"),
    "encryptionatrest.releasedate": ("encryptionatrest", "releasedate"),
    "tlstool": ("tlstool", None),
    "sgctl": ("sgctl", None),
}

DEFAULT_FILE = "_config.yml"


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
def die(msg):
    print("error: " + msg, file=sys.stderr)
    sys.exit(1)


def resolve_channel(name):
    if name in CHANNELS:
        return name
    if name in CHANNEL_ALIASES:
        return CHANNEL_ALIASES[name]
    die("unknown channel %r. choose from: %s (aliases: %s)"
        % (name, ", ".join(CHANNELS), ", ".join(CHANNEL_ALIASES)))


def read_lines(path):
    try:
        with open(path, "r", encoding="utf-8", newline="") as f:
            text = f.read()
    except FileNotFoundError:
        die("file not found: %s" % path)
    # keep exact newline style; splitlines(keepends) preserves per-line endings
    return text.splitlines(keepends=True)


def write_lines(path, lines, backup=True):
    if backup:
        try:
            shutil.copy2(path, path + ".bak")
        except FileNotFoundError:
            pass
    with open(path, "w", encoding="utf-8", newline="") as f:
        f.write("".join(lines))


def split_eol(line):
    """Split a raw line into (content_without_newline, newline_str)."""
    m = re.match(r"^(.*?)(\r\n|\n|\r)?$", line, re.S)
    return m.group(1), (m.group(2) or "")


def parse_ver(esv):
    """Return a comparable tuple of ints for a dotted version like 9.4.2.
    Non-numeric trailing bits are ignored for ordering."""
    parts = []
    for p in esv.split("."):
        m = re.match(r"\d+", p)
        parts.append(int(m.group(0)) if m else 0)
    return tuple(parts)


# ---------------------------------------------------------------------------
# Scalar set
# ---------------------------------------------------------------------------
def find_block_range(lines, block):
    """Return (start_idx, end_idx) covering the top-level `block:` and its
    indented children. end_idx is exclusive."""
    start = None
    for i, ln in enumerate(lines):
        content, _ = split_eol(ln)
        if re.match(r"^%s\s*:" % re.escape(block), content):
            start = i
            break
    if start is None:
        return None
    end = len(lines)
    for j in range(start + 1, len(lines)):
        content, _ = split_eol(lines[j])
        if content.strip() == "" or content.lstrip().startswith("#"):
            continue
        # a line that starts at column 0 with a non-space is a new top-level key
        if not content[:1].isspace():
            end = j
            break
    return (start, end)


def replace_scalar(lines, block, subkey, new_value, required=True):
    """Replace the value of `block:` (subkey None) or `block: -> subkey:`.
    Preserves original quoting and any trailing inline comment.
    Returns True if a line was changed. If the key is missing and
    required=False, returns False instead of aborting."""
    rng = find_block_range(lines, block)
    if rng is None:
        if not required:
            return False
        die("top-level key %r not found" % block)
    start, end = rng

    if subkey is None:
        idxs = [start]
        key = block
    else:
        idxs = list(range(start + 1, end))
        key = subkey

    # regex: indent, key:, spaces, optional quote+value+quote OR bare value,
    #        optional trailing comment
    pat = re.compile(
        r"^(?P<indent>\s*)(?P<key>%s)(?P<colon>\s*:\s*)"
        r"(?P<q>[\"'])?(?P<val>.*?)(?P=q)?(?P<comment>\s+#.*)?\s*$"
        % re.escape(key)
    )
    # simpler, robust two-step: capture prefix up to value, quote, value, rest
    pat = re.compile(
        r"^(?P<prefix>\s*%s\s*:\s*)(?P<body>.*?)(?P<comment>\s+#.*)?$"
        % re.escape(key)
    )

    for i in idxs:
        content, nl = split_eol(lines[i])
        m = pat.match(content)
        if not m:
            continue
        # only accept the correct-depth key line
        prefix = m.group("prefix")
        body = m.group("body")
        comment = m.group("comment") or ""

        # detect quoting of existing body
        bstrip = body.strip()
        q = ""
        if len(bstrip) >= 2 and bstrip[0] in "\"'" and bstrip[-1] == bstrip[0]:
            q = bstrip[0]
        new_body = "%s%s%s" % (q, new_value, q)
        lines[i] = "%s%s%s%s" % (prefix, new_body, comment, nl)
        return True
    if not required:
        return False
    target = block if subkey is None else "%s.%s" % (block, subkey)
    die("scalar key %r not found" % target)


def read_scalar(lines, block, subkey):
    """Return the (unquoted) value of block[.subkey], or None if not found."""
    rng = find_block_range(lines, block)
    if rng is None:
        return None
    start, end = rng
    idxs = [start] if subkey is None else list(range(start + 1, end))
    key = block if subkey is None else subkey
    pat = re.compile(
        r"^(?P<prefix>\s*%s\s*:\s*)(?P<body>.*?)(?P<comment>\s+#.*)?$"
        % re.escape(key)
    )
    for i in idxs:
        content, _ = split_eol(lines[i])
        m = pat.match(content)
        if not m:
            continue
        b = m.group("body").strip()
        if len(b) >= 2 and b[0] in "\"'" and b[-1] == b[0]:
            b = b[1:-1]
        return b
    return None


# ---------------------------------------------------------------------------
# List channel handling
# ---------------------------------------------------------------------------
def channel_row_indices(lines, channel):
    """Return (header_idx, [row line indices]) for the given channel under
    sgversions. Rows are lines like '    - a|b|c'."""
    # find sgversions block
    sg = None
    for i, ln in enumerate(lines):
        content, _ = split_eol(ln)
        if re.match(r"^sgversions\s*:", content):
            sg = i
            break
    if sg is None:
        die("top-level key 'sgversions' not found")

    header = None
    header_indent = None
    for i in range(sg + 1, len(lines)):
        content, _ = split_eol(lines[i])
        if content.strip() == "":
            continue
        # stop if we left sgversions (new column-0 key)
        if not content[:1].isspace() and not content.lstrip().startswith("#"):
            break
        m = re.match(r"^(\s+)%s\s*:" % re.escape(channel), content)
        if m:
            header = i
            header_indent = len(m.group(1))
            break
    if header is None:
        die("channel %r not found under sgversions" % channel)

    rows = []
    for i in range(header + 1, len(lines)):
        content, _ = split_eol(lines[i])
        if content.strip() == "":
            continue
        if content.lstrip().startswith("#"):
            continue
        indent = len(content) - len(content.lstrip())
        # a sibling channel or new key at <= header indent ends this channel
        if indent <= header_indent and content.lstrip().startswith("- ") is False:
            break
        if re.match(r"^\s*-\s", content):
            rows.append(i)
        elif indent <= header_indent:
            break
    return header, rows


def parse_row(lines, idx):
    """Return (indent_str, dash_str, fields_list, newline) for a row line."""
    content, nl = split_eol(lines[idx])
    m = re.match(r"^(\s*)(-\s*)(.*)$", content)
    indent, dash, rest = m.group(1), m.group(2), m.group(3)
    fields = rest.split("|")
    return indent, dash, fields, nl


def build_row(indent, dash, fields, nl):
    return "%s%s%s%s" % (indent, dash, "|".join(fields), nl)


def cmd_show(args):
    lines = read_lines(args.file)
    channel = resolve_channel(args.channel)
    cols = CHANNELS[channel]["cols"]
    _, rows = channel_row_indices(lines, channel)
    print("channel: %s" % channel)
    print("columns: %s" % " | ".join(cols))
    print("-" * 60)
    for idx in rows:
        _, _, fields, _ = parse_row(lines, idx)
        print(" | ".join(fields))
    print("-" * 60)
    print("%d rows" % len(rows))


def cmd_set(args):
    key = args.key
    if key not in SCALAR_KEYS:
        die("unknown scalar key %r. valid keys:\n  %s"
            % (key, "\n  ".join(sorted(SCALAR_KEYS))))
    block, subkey = SCALAR_KEYS[key]
    lines = read_lines(args.file)
    replace_scalar(lines, block, subkey, args.value)
    write_lines(args.file, lines, backup=not args.no_backup)
    print("set %s = %s" % (key, args.value))


def channel_has_row(lines, channel, esv, sgv):
    """True if a row with this exact esv AND sgv already exists in `channel`.
    A given esv can legitimately appear under several sgv values, so identity
    is the (esv, sgv) pair -- not esv alone."""
    _, rows = channel_row_indices(lines, channel)
    for idx in rows:
        _, _, fields, _ = parse_row(lines, idx)
        if fields[0] == esv and len(fields) > 1 and fields[1] == sgv:
            return True
    return False


def _add_row(lines, channel, esv, provided, eol_force=None, eol_scope="major",
             skip_if_exists=False):
    """Insert a new row for `esv` into `channel` (mutates `lines` in place).

    `provided` maps column name -> value (or None to inherit from the newest
    same-major row). A row is identified by (esv, sgv); the same esv may appear
    under several sgv values. `eol_force` overrides the new row's eol; otherwise
    eol is auto-managed. Returns (computed_eol, flipped_count), or None if the
    (esv, sgv) row already exists and skip_if_exists is True. Raises via die()
    on an exact duplicate when skip_if_exists is False.
    """
    cols = CHANNELS[channel]["cols"]
    eol_col = cols.index(CHANNELS[channel]["eol"])
    header, rows = channel_row_indices(lines, channel)

    new_ver = parse_ver(esv)
    new_major = new_ver[0]
    new_minor = new_ver[1] if len(new_ver) > 1 else 0

    parsed = []  # (idx, fields)
    for idx in rows:
        _, _, fields, _ = parse_row(lines, idx)
        parsed.append((idx, fields))

    # newest same-major row provides column defaults
    same_major = [(idx, f) for idx, f in parsed if parse_ver(f[0])[0] == new_major]
    template = same_major[0][1] if same_major else (parsed[0][1] if parsed else None)

    if template is not None and len(template) == len(cols):
        fields = list(template)
    else:
        fields = ["" for _ in cols]
    fields[0] = esv

    for cname, val in (provided or {}).items():
        if val is not None and cname in cols:
            fields[cols.index(cname)] = val

    # identity check on the resolved (esv, sgv) pair
    new_sgv = fields[1] if len(fields) > 1 else ""
    for idx, f in parsed:
        if f[0] == esv and len(f) > 1 and f[1] == new_sgv:
            if skip_if_exists:
                return None
            die("row %s|%s already exists in %s (use `modify`)"
                % (esv, new_sgv, channel))
    new_key = (new_ver, parse_ver(new_sgv))

    # ---- EOL logic -------------------------------------------------------
    scope_rows = parsed if eol_scope == "all" else same_major
    existing_minors = [
        (parse_ver(f[0])[1] if len(parse_ver(f[0])) > 1 else 0)
        for _, f in scope_rows
    ]
    max_minor = max(existing_minors) if existing_minors else None

    if eol_force is not None:
        computed_eol = eol_force
        flip_older = (max_minor is not None and new_minor > max_minor)
    elif max_minor is None:
        computed_eol, flip_older = "no", False
    elif new_minor > max_minor:
        computed_eol, flip_older = "no", True
    elif new_minor == max_minor:
        computed_eol, flip_older = "no", False
    else:
        computed_eol, flip_older = "yes", False

    fields[eol_col] = computed_eol

    flipped = 0
    if flip_older:
        for idx, f in scope_rows:
            if len(f) > eol_col and f[eol_col] != "yes":
                f[eol_col] = "yes"
                ind, dash, _, nl = parse_row(lines, idx)
                lines[idx] = build_row(ind, dash, f, nl)
                flipped += 1

    # ---- insert new row at sorted position -------------------------------
    if rows:
        ind, dash, _, nl = parse_row(lines, rows[0])
    else:
        ind, dash, nl = "    ", "- ", "\n"
    new_line = build_row(ind, dash, fields, nl)

    # keep descending order by (esv, sgv): higher sgv sits above the same esv
    insert_at = None
    for idx, f in parsed:
        row_key = (parse_ver(f[0]), parse_ver(f[1]) if len(f) > 1 else ())
        if row_key < new_key:
            insert_at = idx
            break
    if insert_at is None:
        insert_at = rows[-1] + 1 if rows else header + 1
    lines.insert(insert_at, new_line)

    return computed_eol, flipped


def cmd_add(args):
    channel = resolve_channel(args.channel)
    lines = read_lines(args.file)
    provided = {
        "sgv": args.sgv, "kbv": args.kbv, "available": args.available,
        "kubernetes": args.kubernetes, "helm": args.helm,
        # a brand-new row is dated now unless overridden (never inherit a stale date)
        "release-date": args.release_date if args.release_date is not None else today_iso(),
    }
    computed_eol, flipped = _add_row(
        lines, channel, args.esv, provided,
        eol_force=args.eol, eol_scope=args.eol_scope)
    write_lines(args.file, lines, backup=not args.no_backup)
    print("added %s to %s (eol=%s)%s"
          % (args.esv, channel, computed_eol,
             (", flipped %d older row(s) to eol=yes" % flipped) if flipped else ""))


def cmd_new_release(args):
    """Shortcut for the common case: publish a Search Guard FLX release.

    Adds the row to search-guard-flx-<major> and to
    search-guard-encryption-at-rest, then updates the elasticsearch.* and
    searchguard.* current-version pointers.
    """
    esv = args.esv
    sgv = args.sgv
    ver = parse_ver(esv)
    major = ver[0]
    minor = ver[1] if len(ver) > 1 else 0
    flx = "search-guard-flx-%d" % major
    if flx not in CHANNELS:
        die("no FLX channel for major %d (esv %s); only %s are supported"
            % (major, esv, ", ".join(k for k in CHANNELS if k.startswith("search-guard-flx"))))
    ear = "search-guard-encryption-at-rest"

    rel_date = args.release_date if args.release_date is not None else today_iso()

    lines = read_lines(args.file)

    # --- pre-check: a release is identified by (esv, sgv) -----------------
    # (the same esv may ship under several sgv values). die before writing.
    if channel_has_row(lines, flx, esv, sgv):
        die("row %s|%s already exists in %s" % (esv, sgv, flx))

    # current major = major of elasticsearch.currentversion (authoritative)
    cur_cv = read_scalar(lines, "elasticsearch", "currentversion")
    cur_major = parse_ver(cur_cv)[0] if cur_cv else major
    is_last_major = major < cur_major

    # --- 1) FLX channel row ----------------------------------------------
    flx_provided = {
        "sgv": sgv,
        "kbv": args.kbv if args.kbv is not None else sgv,
        "helm": args.helm if args.helm is not None else (sgv + "-flx"),
        "available": args.available,          # None -> inherit (yes)
        "kubernetes": args.kubernetes,        # None -> inherit
        "release-date": rel_date,
    }
    flx_eol, flx_flip = _add_row(
        lines, flx, esv, flx_provided,
        eol_force=args.eol, eol_scope=args.eol_scope)

    # --- 2) encryption-at-rest row ---------------------------------------
    # EAR tracks which ES versions the plugin supports; a same-esv SG re-spin
    # doesn't add a new EAR row, so skip it if (esv, ear-sgv) is already there.
    ear_provided = {
        "sgv": args.ear_sgv,        # None -> inherit EAR product version
        "available": args.available,
        "release-date": rel_date,
    }
    ear_res = _add_row(
        lines, ear, esv, ear_provided,
        eol_force=args.eol, eol_scope=args.eol_scope, skip_if_exists=True)
    ear_added = ear_res is not None

    # --- 3) scalar pointers ----------------------------------------------
    changed = []
    if is_last_major:
        # only the last-major pointer still exists in the config
        replace_scalar(lines, "elasticsearch", "currentversionlastmajor", esv)
        changed += ["elasticsearch.currentversionlastmajor=%s" % esv]
    else:
        replace_scalar(lines, "elasticsearch", "minorversion", "%d.%d" % (major, minor))
        replace_scalar(lines, "elasticsearch", "currentversion", esv)
        replace_scalar(lines, "searchguard", "currentversion", sgv)
        changed += ["elasticsearch.minorversion=%d.%d" % (major, minor),
                    "elasticsearch.currentversion=%s" % esv,
                    "searchguard.currentversion=%s" % sgv]
        # sync searchguard release date with the new flx row (optional field)
        if replace_scalar(lines, "searchguard", "releasedate", rel_date, required=False):
            changed.append("searchguard.releasedate=%s" % rel_date)
        # sync the encryptionatrest block only when an EAR row was actually added
        if ear_added:
            replace_scalar(lines, "encryptionatrest", "currentversionelasticsearch", esv)
            changed.append("encryptionatrest.currentversionelasticsearch=%s" % esv)
            if replace_scalar(lines, "encryptionatrest", "releasedate", rel_date, required=False):
                changed.append("encryptionatrest.releasedate=%s" % rel_date)
            if args.ear_sgv is not None:
                replace_scalar(lines, "encryptionatrest", "currentversion", args.ear_sgv)
                changed.append("encryptionatrest.currentversion=%s" % args.ear_sgv)

    write_lines(args.file, lines, backup=not args.no_backup)

    print("new-release %s (sg %s)%s" % (esv, sgv,
          " [last-major maintenance]" if is_last_major else ""))
    print("  %s: added (eol=%s)%s" % (flx, flx_eol,
          ", flipped %d older" % flx_flip if flx_flip else ""))
    if ear_added:
        ear_eol, ear_flip = ear_res
        print("  %s: added (eol=%s)%s" % (ear, ear_eol,
              ", flipped %d older" % ear_flip if ear_flip else ""))
    else:
        print("  %s: already present for this esv, skipped" % ear)
    print("  scalars: %s" % ", ".join(changed))


def cmd_modify(args):
    channel = resolve_channel(args.channel)
    cols = CHANNELS[channel]["cols"]
    lines = read_lines(args.file)
    _, rows = channel_row_indices(lines, channel)

    matches = []
    for idx in rows:
        _, _, fields, _ = parse_row(lines, idx)
        if fields[0] == args.esv:
            matches.append(idx)
    if not matches:
        die("esv %s not found in %s" % (args.esv, channel))
    if len(matches) > 1 and not args.all:
        die("esv %s matches %d rows in %s; pass --all to change them all"
            % (args.esv, len(matches), channel))

    provided = {
        "esv": args.new_esv, "sgv": args.sgv, "kbv": args.kbv,
        "available": args.available, "eol": args.eol,
        "kubernetes": args.kubernetes, "helm": args.helm,
        "release-date": args.release_date,
    }
    changes = {c: v for c, v in provided.items() if v is not None and c in cols}
    if not changes:
        die("nothing to change; pass at least one column flag")

    for idx in matches:
        ind, dash, fields, nl = parse_row(lines, idx)
        for c, v in changes.items():
            fields[cols.index(c)] = v
        lines[idx] = build_row(ind, dash, fields, nl)

    write_lines(args.file, lines, backup=not args.no_backup)
    print("modified %s in %s (%s)"
          % (args.esv, channel, ", ".join("%s=%s" % kv for kv in changes.items())))


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------
def build_parser():
    p = argparse.ArgumentParser(
        prog="sgconfig.py",
        description="Surgical editor for _config.yml (Search Guard docs).",
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    p.add_argument("-f", "--file", default=DEFAULT_FILE,
                   help="path to _config.yml (default: %(default)s)")
    p.add_argument("--no-backup", action="store_true",
                   help="do not write a .bak copy before saving")
    sub = p.add_subparsers(dest="cmd", required=True)

    sp = sub.add_parser("set", help="set a scalar key")
    sp.add_argument("key", help="e.g. elasticsearch.currentversion, tlstool")
    sp.add_argument("value")
    sp.set_defaults(func=cmd_set)

    nr = sub.add_parser(
        "new-release",
        help="shortcut: publish an SG FLX release (flx channel + EAR + scalars)")
    nr.add_argument("--esv", required=True, help="elasticsearch version e.g. 9.4.3")
    nr.add_argument("--sgv", required=True, help="search guard version e.g. 4.2.0")
    nr.add_argument("--kbv", help="kibana version (default: same as --sgv)")
    nr.add_argument("--helm", help="helm chart (default: <sgv>-flx)")
    nr.add_argument("--available", help="available column (default: inherit)")
    nr.add_argument("--kubernetes", help="kubernetes range (default: inherit)")
    nr.add_argument("--ear-sgv", help="encryption-at-rest version (default: inherit)")
    nr.add_argument("--release-date", help="release date YYYY-MM-DD (default: today)")
    nr.add_argument("--eol", choices=["yes", "no"],
                    help="force eol for the new rows (otherwise auto-managed)")
    nr.add_argument("--eol-scope", choices=["major", "all"], default="major",
                    help="scope of older-row eol flip on minor bump (default: major)")
    nr.set_defaults(func=cmd_new_release)

    ap = sub.add_parser("add", help="add a new version row to a channel")
    ap.add_argument("channel", help="flx-9 | flx-8 | ear (or full key)")
    ap.add_argument("--esv", required=True, help="new elasticsearch version e.g. 9.4.3")
    ap.add_argument("--sgv")
    ap.add_argument("--kbv")
    ap.add_argument("--available")
    ap.add_argument("--eol", choices=["yes", "no"],
                    help="force eol for the new row (otherwise auto-managed)")
    ap.add_argument("--kubernetes")
    ap.add_argument("--helm")
    ap.add_argument("--release-date", help="release date YYYY-MM-DD (default: today)")
    ap.add_argument("--eol-scope", choices=["major", "all"], default="major",
                    help="scope of older-row eol flip on minor bump (default: major)")
    ap.set_defaults(func=cmd_add)

    mp = sub.add_parser("modify", help="modify an existing version row")
    mp.add_argument("channel", help="flx-9 | flx-8 | ear (or full key)")
    mp.add_argument("esv", help="esv of the row to modify")
    mp.add_argument("--new-esv", help="rename the esv")
    mp.add_argument("--sgv")
    mp.add_argument("--kbv")
    mp.add_argument("--available")
    mp.add_argument("--eol", choices=["yes", "no"])
    mp.add_argument("--kubernetes")
    mp.add_argument("--helm")
    mp.add_argument("--release-date", help="release date YYYY-MM-DD")
    mp.add_argument("--all", action="store_true",
                    help="modify all rows matching esv (for duplicate esv)")
    mp.set_defaults(func=cmd_modify)

    shp = sub.add_parser("show", help="print a channel's rows")
    shp.add_argument("channel")
    shp.set_defaults(func=cmd_show)

    return p


def main(argv=None):
    args = build_parser().parse_args(argv)
    args.func(args)


if __name__ == "__main__":
    main()

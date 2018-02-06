const search = instantsearch({
    appId: '2ESDTH812Y',
    apiKey: '0047035979f052146a69e1d0300cd332',
    indexName: 'v5',
    urlSync: true,
    searchParameters: {
        facetingAfterDistinct: true,
        snippetEllipsisText: "..."
    }
});

search.addWidget(
    instantsearch.widgets.hits({
        container: '#hits',
        templates: {
            empty: '<h2>No results found, please refine your search.</h2>',
            item(data) {
                return formatHit(data)
            }
        }
    })
);

search.addWidget(
    instantsearch.widgets.searchBox({
        container: '#search-box',
        placeholder: 'Search ...'
    })
);

// initialize RefinementLists

search.addWidget(
    instantsearch.widgets.refinementList({
        container: '#refinement-list-category',
        attributeName: 'category_name'
    })
);

search.addWidget(
    instantsearch.widgets.refinementList({
        container: '#refinement-list-h1',
        attributeName: 'h1'
    })
);

search.start();

function formatHit(item) {
    var unique_hierarchy = item.unique_hierarchy;
    var headline = item._highlightResult.text ? item._highlightResult.text.value : item.text;
    var text = item._snippetResult.text_all.value;
    return "<div class='sr_headline'><h2>" + headline + "</h2></div>" +
        "<div class='sr_hierarchy'><a alt='" + headline + "' href='/v5" + item.url + item.css_selector + "'><h5>" + unique_hierarchy + "</h5></a></div>" +
        "<div class='sr_text'>" + text + "</div>";
}
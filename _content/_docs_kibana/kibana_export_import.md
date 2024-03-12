## Export and import procedure during switching Multi Tenancy

The procedure for exporting and importing data during the transition of multi-tenancy 
involves a systematic approach to ensure the seamless transfer of information
and configurations. This methodical process is crucial for preserving data integrity
and sustaining operational continuity within the multi-tenant environment.

### Switching Multi Tenancy: export and import procedure

1. To export saved objects of a user, please follow the official [manual](https://www.elastic.co/guide/en/kibana/current/saved-objects-api-export.html) 

    > Exported data should be saved in NDJSON (Newline Delimited JSON) file 

    Sample POST call should look like below:

   ```
    curl -H 'Authorization: Basic YWRtaW46YWRtaW4=' \
    --request POST \
    -H 'kbn-xsrf: true' \
    -H 'Content-Type: application/json' \
    'localhost:5601/api/saved_objects/_export' \
    -d '{ "type": "*" }' \
    > exportFile.ndjson
   ```

    Please ensure, that all the demanded data was exported to result file


2. Enable or disable Multi Tenancy with SGCTL
     
    Above can be achieved by calling following command using prepared SG 
    configuration file, that contains property `enabled`, which should be set to `true` or `false`
    depending on Multi Tenance state, that is demanded.

    ```
    ./sgctl.sh update-config es/plugins/search-guard-flx/sgconfig/sg_frontend_multi_tenancy.yml
    ```

    Please ensure kibana configuration was changed accordingly.


3. Remove data from Kibana indices, that were exported
4. Import saved objects from previously exported NDSJON file using [manual](https://www.elastic.co/guide/en/kibana/current/saved-objects-api-import.html)

    Sample POST call sould look like below:

    ```
   curl -H 'Authorization: Basic YWRtaW46YWRtaW4=' \
    --request POST \
    -H "kbn-xsrf: true" \
    --form file=@exportFile.ndjson \
    'localhost:5601/api/saved_objects/_import?createNewCopies=true'
    ```
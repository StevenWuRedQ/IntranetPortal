[
    {
        "BaseTable": "LeadInfoDocSearchView",
        "IncludeAppId": "false",
        "Fields": [
            {
                "category": "Lead Info Searchs",
                "fields": [
                  {
                      "name": "Leads Name",
                      "table": "LeadInfoDocSearchView",
                      "column": "LeadsName",
                      "type": "string"
                  },
                   
                  {
                      "name": "Applicant",
                      "table": "LeadInfoDocSearchView",
                      "column": "CreateBy",
                      "type": "string"
                  },
                  {
                      "name": "Submit date",
                      "table": "LeadInfoDocSearchView",
                      "column": "CreateDate",
                      "type": "date"
                  },
                 
                  {
                      "name": "Searched By",
                      "table": "LeadInfoDocSearchView",
                      "column": "UpdateBy",
                      "type": "string"
                  },
                  {
                      "name": "Completed date",
                      "table": "LeadInfoDocSearchView",
                      "column": "UpdateDate",
                      "type": "date"
                  },
                   {
                       "name": "Status",
                       "table": "LeadInfoDocSearchView",
                       "column": "Status",
                       "type": "list",
                       "options": [
                          "New Search",
                          "Completed"
                       ]
                   }
                ]
            }

        ]
    }               
]

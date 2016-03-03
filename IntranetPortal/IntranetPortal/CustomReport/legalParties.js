[
    {
        "BaseTable": "LegalSecondaryActions",
        "IncludeAppId": "false",
        "Fields": [
                    {
                        "category": "General",
                        "fields": [
                          {
                              "name": "BBLE",
                              "table": "LegalCaseJsonView",
                              "column": "BBLE",
                              "type": "string"
                          },
                          {
                              "name": "CaseName",
                              "table": "LegalCaseJsonView",
                              "column": "CaseName",
                              "type": "string"
                          },
                          {
                              "name": "LastUpdateDate",
                              "table": "LegalCaseJsonView",
                              "column": "UpdateDate",
                              "type": "date"
                          },
                          {
                              "name": "LastUpdateBy",
                              "table": "LegalCaseJsonView",
                              "column": "UpdateBy",
                              "type": "string"
                          },

                          {
                              "name": "Status",
                              "table": "LegalCaseJsonView",
                              "column": "Status",
                              "type": "string"
                          }
                        ]
                    },

                    {
                        "category": "LegalSecondaryActions",
                        "fields": [
                          {
                              "name": "Plaintiff",
                              "table": "LegalSecondaryActions",
                              "column": "Plaintiff",
                              "type": "string"
                          },
                          {
                              "name": "PlaintiffAttorney",
                              "table": "LegalSecondaryActions",
                              "column": "PlaintiffAttorney",
                              "type": "string"
                          },
                          {
                              "name": "Defendant",
                              "table": "LegalSecondaryActions",
                              "column": "Defendant",
                              "type": "string"
                          },
                          {
                              "name": "DefendantAttorney",
                              "table": "LegalSecondaryActions",
                              "column": "DefendantAttorney",
                              "type": "string"
                          },
                          {
                              "name": "Tag",
                              "table": "LegalSecondaryActions",
                              "column": "Tag",
                              "type": "string"
                          }
                        ]
                    }
        ]
    }
]


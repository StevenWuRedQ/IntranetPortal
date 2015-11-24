[
    {
        "BaseTable": "LegalCaseJsonView",
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
                        "category": "Foreclosure",
                        "fields":
                        [{
                            "name": "FCPlantiff",
                            "table": "LegalCaseJsonView",
                            "column": "FCPlantiff",
                            "type": "string"
                        },
                        {
                            "name": "FCPlaintiffAttorney",
                            "table": "LegalCaseJsonView",
                            "column": "FCPlaintiffAttorney",
                            "type": "string"
                        },
                        {
                            "name": "FCIndexNum",
                            "table": "LegalCaseJsonView",
                            "column": "JFCIndexNumber",
                            "type": "string"
                        },
                        {
                            "name": "HasTaxLien",
                            "table": "LegalCaseJsonView",
                            "column": "hasTaxLien",
                            "type": "string"
                        },

                        {
                            "name": "taxLienAmout",
                            "table": "LegalCaseJsonView",
                            "column": "taxLienAmout",
                            "type": "string"
                        },
                          {
                              "name": "TaxLienFCStatus",
                              "table": "LegalJTaxLienStatus",
                              "column": "TaxLienFCStatus",
                              "type": "string"
                          }
                          , {
                              "name": "MortageFCStatus",
                              "table": "LegalMortageLienView",
                              "column": "MortageFCStatus",
                              "type": "string"
                          }
                          , {
                              "name": "SecondaryActions",
                              "table": "LegalSecondaryAction_View",
                              "column": "JSecondaryActions",
                              "type": "string"
                          }
                        ]
                    },
                   

                    {
                        "category": "OSC",
                        "fields": [

                          {
                              "name": "OSCPlantiff",
                              "table": "LegalOTSC_VIew",
                              "column": "OSCPlantiff",
                              "type": "string"
                          },
                          {
                              "name": "OSCPlaintiffAttorney",
                              "table": "LegalOTSC_VIew",
                              "column": "OSCPlaintiffAttorney",
                              "type": "string"
                          },
                          {
                              "name": "OSCDefendant",
                              "table": "LegalOTSC_VIew",
                              "column": "OSCDefendant",
                              "type": "string"
                          },
                          {
                              "name": "OSCDefendantAttorney",
                              "table": "LegalOTSC_VIew",
                              "column": "OSCDefendantAttorney",
                              "type": "string"
                          },
                          {
                              "name": "Tag",
                              "table": "LegalOTSC_VIew",
                              "column": "Tag",
                              "type": "string"
                          }
                        ]
                    },
                    {
                        "category": "Legal Partition",
                        "fields": [

                          {
                              "name": "PartitionsPlantiff",
                              "table": "LegalPartition_view",
                              "column": "PartitionsPlantiff",
                              "type": "string"
                          },
                          {
                              "name": "PartitionsDefendant1",
                              "table": "LegalPartition_view",
                              "column": "PartitionsDefendant1",
                              "type": "string"
                          },
                          {
                              "name": "PartitionsDefendant",
                              "table": "LegalPartition_view",
                              "column": "PartitionsDefendant",
                              "type": "string"
                          },
                          {
                              "name": "PartitionsPlantiffAttorney",
                              "table": "LegalPartition_view",
                              "column": "PartitionsPlantiffAttorney",
                              "type": "string"
                          },
                          {
                              "name": "Tag",
                              "table": "LegalPartition_view",
                              "column": "Tag",
                              "type": "string"
                          }
                        ]
                    },
                    {
                        "category": "Legal QTA",
                        "fields": [

                          {
                              "name": "QTA_Plantiff",
                              "table": "LegalQTA_View",
                              "column": "QTA_Plantiff",
                              "type": "string"
                          },
                          {
                              "name": "QTA_PlantiffAttorney",
                              "table": "LegalQTA_View",
                              "column": "QTA_PlantiffAttorney",
                              "type": "string"
                          },
                          {
                              "name": "QTA_Defendant",
                              "table": "LegalQTA_View",
                              "column": "QTA_Defendant",
                              "type": "string"
                          },
                          {
                              "name": "Tag",
                              "table": "LegalQTA_View",
                              "column": "Tag",
                              "type": "string"
                          }
                        ]
                    },
                    {
                        "category": "Legal Specific Performance",
                        "fields": [

                          {
                              "name": "SPComplaint_Plantiff",
                              "table": "LegalSpecificPerformance_View",
                              "column": "SPComplaint_Plantiff",
                              "type": "string"
                          },
                          {
                              "name": "SPComplaint_PlantiffAttorney",
                              "table": "LegalSpecificPerformance_View",
                              "column": "SPComplaint_PlantiffAttorney",
                              "type": "string"
                          },
                          {
                              "name": "SPComplaint_Defendant",
                              "table": "LegalSpecificPerformance_View",
                              "column": "SPComplaint_Defendant",
                              "type": "string"
                          },
                          {
                              "name": "Tag",
                              "table": "LegalSpecificPerformance_View",
                              "column": "Tag",
                              "type": "string"
                          }
                        ]
                    }
        ]
    }
]


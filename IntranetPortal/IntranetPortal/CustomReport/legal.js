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
                              "name": "OSC Plantiff",
                              "table": "LegalOTSC_VIew",
                              "column": "OSCPlantiff",
                              "type": "string"
                          },
                          {
                              "name": "OSC Plaintiff Attorney",
                              "table": "LegalOTSC_VIew",
                              "column": "OSCPlaintiffAttorney",
                              "type": "string"
                          },
                          {
                              "name": "OSC Defendant",
                              "table": "LegalOTSC_VIew",
                              "column": "OSCDefendant",
                              "type": "string"
                          },
                          {
                              "name": "OSC Defendant Attorney",
                              "table": "LegalOTSC_VIew",
                              "column": "OSCDefendantAttorney",
                              "type": "string"
                          },
                          {
                              "name": "OSC Tag",
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
                              "name": "Partition Plantiff",
                              "table": "LegalPartition_view",
                              "column": "PartitionsPlantiff",
                              "type": "string"
                          },
                          {
                              "name": "Partition Defendant1",
                              "table": "LegalPartition_view",
                              "column": "PartitionsDefendant1",
                              "type": "string"
                          },
                          {
                              "name": "Partition Defendant",
                              "table": "LegalPartition_view",
                              "column": "PartitionsDefendant",
                              "type": "string"
                          },
                          {
                              "name": "Partition Plantiff Attorney",
                              "table": "LegalPartition_view",
                              "column": "PartitionsPlantiffAttorney",
                              "type": "string"
                          },
                          {
                              "name": "Partition Tag",
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
                              "name": "QTA Plantiff",
                              "table": "LegalQTA_View",
                              "column": "QTA_Plantiff",
                              "type": "string"
                          },
                          {
                              "name": "QTA PlantiffAttorney",
                              "table": "LegalQTA_View",
                              "column": "QTA_PlantiffAttorney",
                              "type": "string"
                          },
                          {
                              "name": "QTA Defendant",
                              "table": "LegalQTA_View",
                              "column": "QTA_Defendant",
                              "type": "string"
                          },
                          {
                              "name": "QTA Tag",
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
                              "name": "Specific Plantiff",
                              "table": "LegalSpecificPerformance_View",
                              "column": "SPComplaint_Plantiff",
                              "type": "string"
                          },
                          {
                              "name": "Specific PlantiffAttorney",
                              "table": "LegalSpecificPerformance_View",
                              "column": "SPComplaint_PlantiffAttorney",
                              "type": "string"
                          },
                          {
                              "name": "Specific Defendant",
                              "table": "LegalSpecificPerformance_View",
                              "column": "SPComplaint_Defendant",
                              "type": "string"
                          },
                          {
                              "name": "Specific Tag",
                              "table": "LegalSpecificPerformance_View",
                              "column": "Tag",
                              "type": "string"
                          }
                        ]
                    }, {
                        "category": "Deed Reversions",
                        "fields": [

                          {
                              "name": "Deed Reversion Plantiff",
                              "table": "LegalDeedReversions_View",
                              "column": "DeedReversionPlantiff",
                              "type": "string"
                          },
                          {
                              "name": "Deed Reversion Plantiff Attorney" ,
                              "table": "LegalDeedReversions_View",
                              "column": "DeedReversionPlantiffAttorney",
                              "type": "string"
                          },
                          {
                              "name": "Deed Reversion Defendant",
                              "table": "LegalDeedReversions_View",
                              "column": "DeedReversionDefendant",
                              "type": "string"
                          },
                          {
                              "name": "Deed Reversion Tag",
                              "table": "LegalDeedReversions_View",
                              "column": "Tag",
                              "type": "string"
                          }
                        ]
                    }
        ]
    }
]


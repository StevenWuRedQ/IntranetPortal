[
    {
        "BaseTable": "ShortSaleCase",
        "Fields": [
                    {
                        "category": "Seller1",
                        "fields": [
                          {
                              "name": "NAME",
                              "table": "SS_Seller1",
                              "column": "FullName",
                              "type": "string"
                          },
                          {
                              "name": "DOB",
                              "table": "SS_Seller1",
                              "column": "DOB",
                              "type": "date"
                          },
                          {
                              "name": "SSN",
                              "table": "SS_Seller1",
                              "column": "SSN",
                              "type": "number"
                          },
                          {
                              "name": "Mail Address",
                              "table": "SS_Seller1",
                              "column": "MailAddress",
                              "type": "string"
                          },
                          {
                              "name": "Cell #",
                              "table": "SS_Seller1",
                              "column": "Phone",
                              "type": "string"
                          },
                          {
                              "name": "Additional #",
                              "table": "SS_Seller1",
                              "column": "AdlPhone",
                              "type": "string"
                          },
                          {
                              "name": "Email Address",
                              "table": "SS_Seller1",
                              "column": "Email",
                              "type": "string"
                          },
                           {
                               "name": "BANKRUPTCY",
                               "table": "SS_Seller1",
                               "column": "Bankruptcy",
                               "type": "boolean"
                           },
                          {
                              "name": "BANK ACCOUNT",
                              "table": "SS_Seller1",
                              "column": "Bankaccount",
                              "type": "boolean"

                          },
                          {
                              "name": "TAX RETURNS",
                              "table": "SS_Seller1",
                              "column": "TaxReturn",
                              "type": "boolean"
                          },
                          {
                              "name": "EMPLOYED",
                              "table": "SS_Seller1",
                              "column": "Employed",
                              "type": "string"
                          },
                          {
                              "name": "PAYSTUBS",
                              "table": "SS_Seller1",
                              "column": "Paystubs",
                              "type": "boolean"
                          }
                        ]
                    },
                    {
                        "category": "Seller2",
                        "fields": [
                           {
                               "name": "NAME",
                               "table": "SS_Seller2",
                               "column": "FullName",
                               "type": "string"
                           },
                          {
                              "name": "DOB",
                              "table": "SS_Seller2",
                              "column": "DOB",
                              "type": "date"
                          },
                          {
                              "name": "SSN",
                              "table": "SS_Seller2",
                              "column": "SSN",
                              "type": "number"
                          },
                          {
                              "name": "Mail Address",
                              "table": "SS_Seller2",
                              "column": "MailAddress",
                              "type": "string"
                          },
                          {
                              "name": "Cell #",
                              "table": "SS_Seller2",
                              "column": "Phone",
                              "type": "string"
                          },
                          {
                              "name": "Additional #",
                              "table": "SS_Seller2",
                              "column": "AdlPhone",
                              "type": "string"
                          },
                          {
                              "name": "Email Address",
                              "table": "SS_Seller2",
                              "column": "Email",
                              "type": "string"
                          },
                           {
                               "name": "BANKRUPTCY",
                               "table": "SS_Seller2",
                               "column": "Bankruptcy",
                               "type": "boolean"
                           },
                          {
                              "name": "BANK ACCOUNT",
                              "table": "SS_Seller2",
                              "column": "Bankaccount",
                              "type": "boolean"

                          },
                          {
                              "name": "TAX RETURNS",
                              "table": "SS_Seller2",
                              "column": "TaxReturn",
                              "type": "boolean"
                          },
                          {
                              "name": "EMPLOYED",
                              "table": "SS_Seller2",
                              "column": "Employed",
                              "type": "string"
                          },
                          {
                              "name": "PAYSTUBS",
                              "table": "SS_Seller2",
                              "column": "Paystubs",
                              "type": "boolean"
                          }
                        ]
                    },
                      {
                          "category": "Property Address",
                          "fields": [
                            {
                                "name": "BLOCK",
                                "table": "LeadsInfo",
                                "column": "Block",
                                "type": "string"
                            },
                            {
                                "name": "LOT",
                                "table": "LeadsInfo",
                                "column": "Lot",
                                "type": "string"
                            },
                            {
                                "name": "Address",
                                "table": "LeadsInfo",
                                "column": "PropertyAddress",
                                "type": "string"
                            }
                          ]
                      },
                      {
                          "category": "HOME BREAKDOWN",
                          "fields": [
                            {
                                "name": "Floor Id",
                                "table": "SS_Floor1",
                                "column": "FloorId",
                                "type": "number"
                            },
                            {
                                "name": "Description",
                                "table": "SS_Floor1",
                                "column": "Description",
                                "type": "string"
                            }, {
                                "name": "Bedroom",
                                "table": "SS_Floor1",
                                "column": "Bedroom",
                                "type": "number"
                            }, {
                                "name": "Bathroom",
                                "table": "SS_Floor1",
                                "column": "Bathroom",
                                "type": "number"
                            }, {
                                "name": "Livingroom",
                                "table": "SS_Floor1",
                                "column": "Livingroom",
                                "type": "number"
                            }, {
                                "name": "Diningroom",
                                "table": "SS_Floor1",
                                "column": "Diningroom",
                                "type": "number"

                            }, {
                                "name": "Occupied",
                                "table": "SS_Floor1",
                                "column": "Occupied",
                                "type": "list",
                                "options": ["Vacant", "Seller", "Tenants (Coop)", "Tenants (Non-Coop)"]

                            }, {
                                "name": "Access",
                                "table": "SS_Floor1",
                                "column": "Access",
                                "type": "string"

                            }, {
                                "name": "LockBox",
                                "table": "SS_Floor1",
                                "column": "LockBox",
                                "type": "string"

                            }, {
                                "name": "LockupDate",
                                "table": "SS_Floor1",
                                "column": "LockupDate",
                                "type": "date"

                            }, {
                                "name": "LockedBy",
                                "table": "SS_Floor1",
                                "column": "LockedBy",
                                "type": "string"

                            }, {
                                "name": "LastChecked",
                                "table": "SS_Floor1",
                                "column": "LastChecked",
                                "type": "date"
                            }
                          ]

                      },
                      {
                          "category": "BUILDING INFO",
                          "fields": [
                            {
                                "name": "TAX CLASS",
                                "table": "LeadsInfo",
                                "column": "PropertyClass",
                                "type": "string"
                            }
                          ]
                      },
                      {
                          "category": "Mortgage 1",
                          "fields": [
                             {
                                 "name": "HasAuctionDate",
                                 "table": "SSFirstMortgage",
                                 "column": "HasAuctionDate",
                                 "type": "boolean"
                             },
      {
          "name": "AuctionDate",
          "table": "SSFirstMortgage",
          "column": "AuctionDate",
          "type": "date"
      },
      {
          "name": "DateOfSale",
          "table": "SSFirstMortgage",
          "column": "DateOfSale",
          "type": "date"
      },
      {
          "name": "DateVerified",
          "table": "SSFirstMortgage",
          "column": "DateVerified",
          "type": "date"
      },
      {
          "name": "PayoffExpired",
          "table": "SSFirstMortgage",
          "column": "PayoffExpired",
          "type": "date"
      },
      {
          "name": "PayoffRequested",
          "table": "SSFirstMortgage",
          "column": "PayoffRequested",
          "type": "date"
      },
      {
          "name": "PayoffAmount",
          "table": "SSFirstMortgage",
          "column": "PayoffAmount",
          "type": "number"
      },
      {
          "name": "LenderId",
          "table": "SSFirstMortgage",
          "column": "LenderId",
          "type": "number"
      },
      {
          "name": "Lender",
          "table": "SSFirstMortgage",
          "column": "Lender",
          "type": "string"
      },
      {
          "name": "Loan",
          "table": "SSFirstMortgage",
          "column": "Loan",
          "type": "string"
      },
      {
          "name": "LoanAmount",
          "table": "SSFirstMortgage",
          "column": "LoanAmount",
          "type": "number"
      },
      {
          "name": "LastPaymentDate",
          "table": "SSFirstMortgage",
          "column": "LastPaymentDate",
          "type": "date"
      },
      {
          "name": "LoanType",
          "table": "SSFirstMortgage",
          "column": "LoanType",
          "type": "string"
      },
      {
          "name": "AuthorizationSent",
          "table": "SSFirstMortgage",
          "column": "AuthorizationSent",
          "type": "string"
      },
      {
          "name": "CancelationSent",
          "table": "SSFirstMortgage",
          "column": "CancelationSent",
          "type": "date"
      },
      {
          "name": "LienPosition",
          "table": "SSFirstMortgage",
          "column": "LienPosition",
          "type": "string"
      },
      {
          "name": "CounterOffer",
          "table": "SSFirstMortgage",
          "column": "CounterOffer",
          "type": "string"
      },
      {
          "name": "ShortSaleDept",
          "table": "SSFirstMortgage",
          "column": "ShortSaleDept",
          "type": "number"
      },
      {
          "name": "Processor",
          "table": "SSFirstMortgage",
          "column": "Processor",
          "type": "number"
      },
      {
          "name": "Negotiator",
          "table": "SSFirstMortgage",
          "column": "Negotiator",
          "type": "number"
      },
      {
          "name": "Closer",
          "table": "SSFirstMortgage",
          "column": "Closer",
          "type": "number"
      },
      {
          "name": "ForeclosureAttorney",
          "table": "SSFirstMortgage",
          "column": "ForeclosureAttorney",
          "type": "string"
      },
      {
          "name": "ForeclosureAttorneyId",
          "table": "SSFirstMortgage",
          "column": "ForeclosureAttorneyId",
          "type": "number"
      },
      {
          "name": "AssignedAttorney",
          "table": "SSFirstMortgage",
          "column": "AssignedAttorney",
          "type": "string"
      },
      {
          "name": "AttorneyDirectNo",
          "table": "SSFirstMortgage",
          "column": "AttorneyDirectNo",
          "type": "string"
      },
      {
          "name": "AttorneyEmail",
          "table": "SSFirstMortgage",
          "column": "AttorneyEmail",
          "type": "string"
      },
      {
          "name": "Contacts",
          "table": "SSFirstMortgage",
          "column": "Contacts",
          "type": "string"
      },
      {
          "name": "Notes",
          "table": "SSFirstMortgage",
          "column": "Notes",
          "type": "string"
      },
      {
          "name": "DateAssigned",
          "table": "SSFirstMortgage",
          "column": "DateAssigned",
          "type": "date"
      },
      {
          "name": "Supervisor",
          "table": "SSFirstMortgage",
          "column": "Supervisor",
          "type": "number"
      },
      {
          "name": "Category",
          "table": "SSFirstMortgage",
          "column": "Category",
          "type": "string"
      },
      {
          "name": "Status",
          "table": "SSFirstMortgage",
          "column": "Status",
          "type": "string"
      },
      {
          "name": "Fannie",
          "table": "SSFirstMortgage",
          "column": "Fannie",
          "type": "boolean"
      },
      {
          "name": "FHA",
          "table": "SSFirstMortgage",
          "column": "FHA",
          "type": "boolean"
      },
      {
          "name": "Freddie",
          "table": "SSFirstMortgage",
          "column": "Freddie",
          "type": "boolean"
      },
      {
          "name": "LastBPOUpdate",
          "table": "SSFirstMortgage",
          "column": "LastBPOUpdate",
          "type": "date"
      },
      {
          "name": "UpcomingBPODate",
          "table": "SSFirstMortgage",
          "column": "UpcomingBPODate",
          "type": "date"
      },
      {
          "name": "CreateDate",
          "table": "SSFirstMortgage",
          "column": "CreateDate",
          "type": "date"
      },
      {
          "name": "CreateBy",
          "table": "SSFirstMortgage",
          "column": "CreateBy",
          "type": "string"
      },
      {
          "name": "UpdateDate",
          "table": "SSFirstMortgage",
          "column": "UpdateDate",
          "type": "date"
      },
      {
          "name": "UpdateBy",
          "table": "SSFirstMortgage",
          "column": "UpdateBy",
          "type": "string"
      },
      {
          "name": "LenderContactId",
          "table": "SSFirstMortgage",
          "column": "LenderContactId",
          "type": "number"
      },
      {
          "name": "LenderAttorney",
          "table": "SSFirstMortgage",
          "column": "LenderAttorney",
          "type": "number"
      },
      {
          "name": "Type",
          "table": "SSFirstMortgage",
          "column": "Type",
          "type": "string"
      }
                          ]
                      },
                      {
                          "category": "Mortgage 2",
                          "fields": [
                           {
                               "name": "HasAuctionDate",
                               "table": "SSFirstMortgage",
                               "column": "HasAuctionDate",
                               "type": "boolean"
                           },
      {
          "name": "AuctionDate",
          "table": "SSFirstMortgage",
          "column": "AuctionDate",
          "type": "date"
      },
      {
          "name": "DateOfSale",
          "table": "SSFirstMortgage",
          "column": "DateOfSale",
          "type": "date"
      },
      {
          "name": "DateVerified",
          "table": "SSFirstMortgage",
          "column": "DateVerified",
          "type": "date"
      },
      {
          "name": "PayoffExpired",
          "table": "SSFirstMortgage",
          "column": "PayoffExpired",
          "type": "date"
      },
      {
          "name": "PayoffRequested",
          "table": "SSFirstMortgage",
          "column": "PayoffRequested",
          "type": "date"
      },
      {
          "name": "PayoffAmount",
          "table": "SSFirstMortgage",
          "column": "PayoffAmount",
          "type": "number"
      },
      {
          "name": "LenderId",
          "table": "SSFirstMortgage",
          "column": "LenderId",
          "type": "number"
      },
      {
          "name": "Lender",
          "table": "SSFirstMortgage",
          "column": "Lender",
          "type": "string"
      },
      {
          "name": "Loan",
          "table": "SSFirstMortgage",
          "column": "Loan",
          "type": "string"
      },
      {
          "name": "LoanAmount",
          "table": "SSFirstMortgage",
          "column": "LoanAmount",
          "type": "number"
      },
      {
          "name": "LastPaymentDate",
          "table": "SSFirstMortgage",
          "column": "LastPaymentDate",
          "type": "date"
      },
      {
          "name": "LoanType",
          "table": "SSFirstMortgage",
          "column": "LoanType",
          "type": "string"
      },
      {
          "name": "AuthorizationSent",
          "table": "SSFirstMortgage",
          "column": "AuthorizationSent",
          "type": "string"
      },
      {
          "name": "CancelationSent",
          "table": "SSFirstMortgage",
          "column": "CancelationSent",
          "type": "date"
      },
      {
          "name": "LienPosition",
          "table": "SSFirstMortgage",
          "column": "LienPosition",
          "type": "string"
      },
      {
          "name": "CounterOffer",
          "table": "SSFirstMortgage",
          "column": "CounterOffer",
          "type": "string"
      },
      {
          "name": "ShortSaleDept",
          "table": "SSFirstMortgage",
          "column": "ShortSaleDept",
          "type": "number"
      },
      {
          "name": "Processor",
          "table": "SSFirstMortgage",
          "column": "Processor",
          "type": "number"
      },
      {
          "name": "Negotiator",
          "table": "SSFirstMortgage",
          "column": "Negotiator",
          "type": "number"
      },
      {
          "name": "Closer",
          "table": "SSFirstMortgage",
          "column": "Closer",
          "type": "number"
      },
      {
          "name": "ForeclosureAttorney",
          "table": "SSFirstMortgage",
          "column": "ForeclosureAttorney",
          "type": "string"
      },
      {
          "name": "ForeclosureAttorneyId",
          "table": "SSFirstMortgage",
          "column": "ForeclosureAttorneyId",
          "type": "number"
      },
      {
          "name": "AssignedAttorney",
          "table": "SSFirstMortgage",
          "column": "AssignedAttorney",
          "type": "string"
      },
      {
          "name": "AttorneyDirectNo",
          "table": "SSFirstMortgage",
          "column": "AttorneyDirectNo",
          "type": "string"
      },
      {
          "name": "AttorneyEmail",
          "table": "SSFirstMortgage",
          "column": "AttorneyEmail",
          "type": "string"
      },
      {
          "name": "Contacts",
          "table": "SSFirstMortgage",
          "column": "Contacts",
          "type": "string"
      },
      {
          "name": "Notes",
          "table": "SSFirstMortgage",
          "column": "Notes",
          "type": "string"
      },
      {
          "name": "DateAssigned",
          "table": "SSFirstMortgage",
          "column": "DateAssigned",
          "type": "date"
      },
      {
          "name": "Supervisor",
          "table": "SSFirstMortgage",
          "column": "Supervisor",
          "type": "number"
      },
      {
          "name": "Category",
          "table": "SSFirstMortgage",
          "column": "Category",
          "type": "string"
      },
      {
          "name": "Status",
          "table": "SSFirstMortgage",
          "column": "Status",
          "type": "string"
      },
      {
          "name": "Fannie",
          "table": "SSFirstMortgage",
          "column": "Fannie",
          "type": "boolean"
      },
      {
          "name": "FHA",
          "table": "SSFirstMortgage",
          "column": "FHA",
          "type": "boolean"
      },
      {
          "name": "Freddie",
          "table": "SSFirstMortgage",
          "column": "Freddie",
          "type": "boolean"
      },
      {
          "name": "LastBPOUpdate",
          "table": "SSFirstMortgage",
          "column": "LastBPOUpdate",
          "type": "date"
      },
      {
          "name": "UpcomingBPODate",
          "table": "SSFirstMortgage",
          "column": "UpcomingBPODate",
          "type": "date"
      },
      {
          "name": "CreateDate",
          "table": "SSFirstMortgage",
          "column": "CreateDate",
          "type": "date"
      },
      {
          "name": "CreateBy",
          "table": "SSFirstMortgage",
          "column": "CreateBy",
          "type": "string"
      },
      {
          "name": "UpdateDate",
          "table": "SSFirstMortgage",
          "column": "UpdateDate",
          "type": "date"
      },
      {
          "name": "UpdateBy",
          "table": "SSFirstMortgage",
          "column": "UpdateBy",
          "type": "string"
      },
      {
          "name": "LenderContactId",
          "table": "SSFirstMortgage",
          "column": "LenderContactId",
          "type": "number"
      },
      {
          "name": "LenderAttorney",
          "table": "SSFirstMortgage",
          "column": "LenderAttorney",
          "type": "number"
      },
      {
          "name": "Type",
          "table": "SSFirstMortgage",
          "column": "Type",
          "type": "string"
      }
                          ]
                      },
                      {
                          "category": "FORECLOSURE ATTORNEY",
                          "fields": [
                            {
                                "name": "FORECLOSURE ATTORNEY",
                                "table": "SSFirstMortgage",
                                "column": "ForeclosureAttorney",
                                "type": "string"
                            },
                            {
                                "name": "ADDRESS",
                                "table": "",
                                "column": "",
                                "type": "string"
                            },
                            {
                                "name": "OFFICE #",
                                "table": "",
                                "column": "",
                                "type": "string"
                            },
                            {
                                "name": "ASSIGNED ATTORNEY",
                                "table": "",
                                "column": "",
                                "type": "string"
                            },
                            {
                                "name": "ATTORNEY DIRECT #",
                                "table": "",
                                "column": "",
                                "type": "string"
                            }
                          ]
                      },
                      {
                          "category": "Seller TITLE",
                          "fields": [
      {
          "name": "Type",
          "table": "SS_SellerTitle",
          "column": "Type",
          "type": "string"
      },
      {
          "name": "CompanyName",
          "table": "SS_SellerTitle",
          "column": "CompanyName",
          "type": "string"
      },
      {
          "name": "Phone",
          "table": "SS_SellerTitle",
          "column": "Phone",
          "type": "string"
      },
      {
          "name": "ReportOrderDate",
          "table": "SS_SellerTitle",
          "column": "ReportOrderDate",
          "type": "date"
      },
      {
          "name": "ReceivedDate",
          "table": "SS_SellerTitle",
          "column": "ReceivedDate",
          "type": "date"
      },
      {
          "name": "OrderNumber",
          "table": "SS_SellerTitle",
          "column": "OrderNumber",
          "type": "string"
      },
      {
          "name": "ReviewedDate",
          "table": "SS_SellerTitle",
          "column": "ReviewedDate",
          "type": "date"
      },
      {
          "name": "ConfirmationDate",
          "table": "SS_SellerTitle",
          "column": "ConfirmationDate",
          "type": "date"
      },
      {
          "name": "Address",
          "table": "SS_SellerTitle",
          "column": "Address",
          "type": "string"
      },
      {
          "name": "Rep",
          "table": "SS_SellerTitle",
          "column": "Rep",
          "type": "string"
      },
      {
          "name": "RepNo",
          "table": "SS_SellerTitle",
          "column": "RepNo",
          "type": "string"
      },
      {
          "name": "RepEmail",
          "table": "SS_SellerTitle",
          "column": "RepEmail",
          "type": "string"
      },
      {
          "name": "CreateBy",
          "table": "SS_SellerTitle",
          "column": "CreateBy",
          "type": "string"
      },
      {
          "name": "CreateDate",
          "table": "SS_SellerTitle",
          "column": "CreateDate",
          "type": "date"
      }
                          ]
                      },
                      {
                          "category": "LISTING INFO",
                          "fields": [
                            {
                                "name": "MLS",
                                "table": "ShortSaleCases",
                                "column": "MLSStatus",
                                "type": "string"
                            },
                            {
                                "name": "MLS #",
                                "table": "ShortSaleCases",
                                "column": "ListMLS",
                                "type": "string"
                            },
                            {
                                "name": "LIST PRICE",
                                "table": "ShortSaleCases",
                                "column": "ListPrice",
                                "type": "number"
                            },
                            {
                                "name": "LISTING DATE",
                                "table": "ShortSaleCases",
                                "column": "ListingDate",
                                "type": "date"
                            },
                            {
                                "name": "LISTING EXPIRY DATE",
                                "table": "ShortSaleCases",
                                "column": "ListingExpireDate",
                                "type": "date"
                            }
                          ]
                      },
                      {
                          "category": "VALUATIONS",
                          "fields": [
                        {
                            "name": "Method",
                            "table": "SS_Valuation",
                            "column": "Method",
                            "type": "string"
                        },
      {
          "name": "BankValue",
          "table": "SS_Valuation",
          "column": "BankValue",
          "type": "number"
      },
      {
          "name": "MNSP",
          "table": "SS_Valuation",
          "column": "MNSP",
          "type": "number"
      },
      {
          "name": "DateOfValue",
          "table": "SS_Valuation",
          "column": "DateOfValue",
          "type": "date"
      },
      {
          "name": "ExpiredOn",
          "table": "SS_Valuation",
          "column": "ExpiredOn",
          "type": "date"
      },
      {
          "name": "AgentName",
          "table": "SS_Valuation",
          "column": "AgentName",
          "type": "string"
      },
      {
          "name": "AgentPhone",
          "table": "SS_Valuation",
          "column": "AgentPhone",
          "type": "string"
      },
      {
          "name": "DateOfCall",
          "table": "SS_Valuation",
          "column": "DateOfCall",
          "type": "date"
      },
      {
          "name": "TimeOfValue",
          "table": "SS_Valuation",
          "column": "TimeOfValue",
          "type": "string"
      },
      {
          "name": "Access",
          "table": "SS_Valuation",
          "column": "Access",
          "type": "string"
      },
      {
          "name": "IsValuationComplete",
          "table": "SS_Valuation",
          "column": "IsValuationComplete",
          "type": "string"
      },
      {
          "name": "DateComplate",
          "table": "SS_Valuation",
          "column": "DateComplate",
          "type": "date"
      },
      {
          "name": "Pending",
          "table": "SS_Valuation",
          "column": "Pending",
          "type": "boolean"
      }
                          ]
                      },
                      {
                          "category": "OFFERS",
                          "fields": [
                           {
                               "name": "OfferType",
                               "table": "SS_FirstOffer",
                               "column": "OfferType",
                               "type": "string"
                           },
      {
          "name": "DateOfContract",
          "table": "SS_FirstOffer",
          "column": "DateOfContract",
          "type": "date"
      },
      {
          "name": "OfferAmount",
          "table": "SS_FirstOffer",
          "column": "OfferAmount",
          "type": "number"
      },
      {
          "name": "DateSubmited",
          "table": "SS_FirstOffer",
          "column": "DateSubmited",
          "type": "date"
      },
      {
          "name": "CreateDate",
          "table": "SS_FirstOffer",
          "column": "CreateDate",
          "type": "date"
      },
      {
          "name": "CreateBy",
          "table": "SS_FirstOffer",
          "column": "CreateBy",
          "type": "string"
      },
      {
          "name": "Entity",
          "table": "SS_FirstOffer",
          "column": "Entity",
          "type": "string"
      },
      {
          "name": "EntityAddress",
          "table": "SS_FirstOffer",
          "column": "EntityAddress",
          "type": "string"
      },
      {
          "name": "Signor",
          "table": "SS_FirstOffer",
          "column": "Signor",
          "type": "string"
      },
      {
          "name": "DateOpened",
          "table": "SS_FirstOffer",
          "column": "DateOpened",
          "type": "date"
      }
                          ]
                      },
                      {
                          "category": "ASSIGNED PROCESSOR",
                          "fields": [
                            {
                                "name": "NAME",
                                "table": "ShortSaleCases",
                                "column": "ProcessorName",
                                "type": "string"
                            },
                            {
                                "name": "PHONE #",
                                "table": "SS_Processor",
                                "column": "OfficeNO",
                                "type": "string"
                            },
                            {
                                "name": "EMAIL",
                                "table": "SS_Processor",
                                "column": "Email",
                                "type": "string"
                            }
                          ]
                      },
                      {
                          "category": "REFERRAL",
                          "fields": [
                            {
                                "name": "AGENT",
                                "table": "ShortSaleCases",
                                "column": "ReferralUserName",
                                "type": "string"
                            },
                            {
                                "name": "AGENT CELL #",
                                "table": "SS_Referral",
                                "column": "OfficeNO",
                                "type": "string"
                            },
                            {
                                "name": "AGENT EMAIL",
                                "table": "SS_Referral",
                                "column": "Email",
                                "type": "string"
                            },
                            {
                                "name": "TEAM",
                                "table": "ShortSaleCases",
                                "column": "ReferralTeam",
                                "type": "string"
                            },
                            {
                                "name": "ADDRESS",
                                "table": "SS_ReferralTeam",
                                "column": "Address",
                                "type": "string"
                            },
                            {
                                "name": "OFFICE #",
                                "table": "SS_ReferralTeam",
                                "column": "OfficeNo",
                                "type": "string"
                            },
                            {
                                "name": "MANAGER",
                                "table": "SS_ReferralTeam",
                                "column": "Manager",
                                "type": "string"
                            },
                            {
                                "name": "MANAGER CELL #",
                                "table": "SS_ReferralTeam",
                                "column": "",
                                "type": "string"
                            },
                            {
                                "name": "MANAGER EMAIL",
                                "table": "SS_ReferralTeam",
                                "column": "",
                                "type": "string"
                            },
                            {
                                "name": "ASSISTANT",
                                "table": "SS_ReferralTeam",
                                "column": "Assistant",
                                "type": "string"
                            },
                            {
                                "name": "ASSISTANT CELL #",
                                "table": "SS_ReferralTeam",
                                "column": "",
                                "type": "string"
                            },
                            {
                                "name": "ASSISTANT EMAIL",
                                "table": "SS_ReferralTeam",
                                "column": "",
                                "type": "string"
                            }
                          ]
                      },
                      {
                          "category": "LISTING AGENT",
                          "fields": [
                            {
                                "name": "NAME",
                                "table": "ShortSaleCases",
                                "column": "ListingAgentName",
                                "type": "string"
                            },
                            {
                                "name": "CELL #",
                                "table": "SS_ListingAgent",
                                "column": "Cell",
                                "type": "string"
                            },
                            {
                                "name": "EMAIL",
                                "table": "SS_ListingAgent",
                                "column": "Email",
                                "type": "string"
                            },
                            {
                                "name": "BROKER",
                                "table": "SS_ListingAgent",
                                "column": "",
                                "type": "string"
                            },
                            {
                                "name": "ADDRESS",
                                "table": "SS_ListingAgent",
                                "column": "Address",
                                "type": "string"
                            },
                            {
                                "name": "OFFICE #",
                                "table": "SS_ListingAgent",
                                "column": "OfficeNO",
                                "type": "string"
                            }
                          ]
                      },
                      {
                          "category": "SELLER ATTORNEY",
                          "fields": [
                            {
                                "name": "NAME",
                                "table": "ShortSaleCases",
                                "column": "SellerAttorneyName",
                                "type": "string"
                            },
                            {
                                "name": "CELL #",
                                "table": "SS_SellerAttorney",
                                "column": "Cell",
                                "type": "string"
                            },
                            {
                                "name": "EMAIL",
                                "table": "SS_SellerAttorney",
                                "column": "Email",
                                "type": "string"
                            },
                            {
                                "name": "OFFICE",
                                "table": "SS_SellerAttorney",
                                "column": "Office",
                                "type": "string"
                            },
                            {
                                "name": "ADDRESS",
                                "table": "SS_SellerAttorney",
                                "column": "Address",
                                "type": "string"
                            },
                            {
                                "name": "OFFICE #",
                                "table": "SS_SellerAttorney",
                                "column": "OfficeNO",
                                "type": "string"
                            }
                          ]
                      },
                      {
                          "category": "BUYER",
                          "fields": [
                           {
                               "name": "Entity",
                               "table": "ShortSaleBuyers",
                               "column": "Entity",
                               "type": "string"
                           },
      {
          "name": "EntityAddress",
          "table": "ShortSaleBuyers",
          "column": "EntityAddress",
          "type": "string"
      },
      {
          "name": "SignorId",
          "table": "ShortSaleBuyers",
          "column": "SignorId",
          "type": "number"
      },
      {
          "name": "Signor",
          "table": "ShortSaleBuyers",
          "column": "Signor",
          "type": "string"
      },
      {
          "name": "DateOpened",
          "table": "ShortSaleBuyers",
          "column": "DateOpened",
          "type": "date"
      },
      {
          "name": "Office",
          "table": "ShortSaleBuyers",
          "column": "Office",
          "type": "string"
      },
      {
          "name": "TaxId",
          "table": "ShortSaleBuyers",
          "column": "TaxId",
          "type": "string"
      },
      {
          "name": "CreateDate",
          "table": "ShortSaleBuyers",
          "column": "CreateDate",
          "type": "date"
      },
      {
          "name": "CreateBy",
          "table": "ShortSaleBuyers",
          "column": "CreateBy",
          "type": "string"
      }
                          ]
                      },
                      {
                          "category": "BUYER ATTORNEY",
                          "fields": [
                            {
                                "name": "NAME",
                                "table": "ShortSaleCases",
                                "column": "BuyerAttorneyName",
                                "type": "string"
                            },
                            {
                                "name": "CELL #",
                                "table": "SS_BuyerAttorney",
                                "column": "Cell",
                                "type": "string"
                            },
                            {
                                "name": "EMAIL",
                                "table": "SS_BuyerAttorney",
                                "column": "Email",
                                "type": "string"
                            },
                            {
                                "name": "OFFICE",
                                "table": "SS_BuyerAttorney",
                                "column": "Office",
                                "type": "string"
                            },
                            {
                                "name": "OFFICE ADDRESS",
                                "table": "SS_BuyerAttorney",
                                "column": "Address",
                                "type": "string"
                            },
                            {
                                "name": "OFFICE #",
                                "table": "SS_BuyerAttorney",
                                "column": "OfficeNO",
                                "type": "string"
                            }
                          ]
                      },
                      {
                          "category": "Buyer Title",
                          "fields": [
                             {
                                 "name": "TitleId",
                                 "table": "SS_BuyerTitle",
                                 "column": "TitleId",
                                 "type": "number"
                             },
      {
          "name": "Type",
          "table": "SS_BuyerTitle",
          "column": "Type",
          "type": "string"
      },
      {
          "name": "ContactId",
          "table": "SS_BuyerTitle",
          "column": "ContactId",
          "type": "number"
      },
      {
          "name": "CompanyName",
          "table": "SS_BuyerTitle",
          "column": "CompanyName",
          "type": "string"
      },
      {
          "name": "Phone",
          "table": "SS_BuyerTitle",
          "column": "Phone",
          "type": "string"
      },
      {
          "name": "ReportOrderDate",
          "table": "SS_BuyerTitle",
          "column": "ReportOrderDate",
          "type": "date"
      },
      {
          "name": "ReceivedDate",
          "table": "SS_BuyerTitle",
          "column": "ReceivedDate",
          "type": "date"
      },
      {
          "name": "OrderNumber",
          "table": "SS_BuyerTitle",
          "column": "OrderNumber",
          "type": "string"
      },
      {
          "name": "ReviewedDate",
          "table": "SS_BuyerTitle",
          "column": "ReviewedDate",
          "type": "date"
      },
      {
          "name": "ConfirmationDate",
          "table": "SS_BuyerTitle",
          "column": "ConfirmationDate",
          "type": "date"
      },
      {
          "name": "Address",
          "table": "SS_BuyerTitle",
          "column": "Address",
          "type": "string"
      },
      {
          "name": "Rep",
          "table": "SS_BuyerTitle",
          "column": "Rep",
          "type": "string"
      },
      {
          "name": "RepNo",
          "table": "SS_BuyerTitle",
          "column": "RepNo",
          "type": "string"
      },
      {
          "name": "RepEmail",
          "table": "SS_BuyerTitle",
          "column": "RepEmail",
          "type": "string"
      },
      {
          "name": "CreateBy",
          "table": "SS_BuyerTitle",
          "column": "CreateBy",
          "type": "string"
      },
      {
          "name": "CreateDate",
          "table": "SS_BuyerTitle",
          "column": "CreateDate",
          "type": "date"
      }
                          ]
                      },
                      {
                          "category": "APPROVAL CHECK LIST",
                          "fields": [
                            {
                                "name": "DATE APPROVAL ISSUED",
                                "table": "",
                                "column": "",
                                "type": "string"
                            },
                            {
                                "name": "DATE APPROVAL EXPIRES",
                                "table": "",
                                "column": "",
                                "type": "string"
                            },
                            {
                                "name": "BUYERS NAME",
                                "table": "",
                                "column": "",
                                "type": "string"
                            },
                            {
                                "name": "CONTRACT PRICE",
                                "table": "",
                                "column": "",
                                "type": "string"
                            },
                            {
                                "name": "DOES NET MATCH - 1ST LIEN",
                                "table": "",
                                "column": "",
                                "type": "string"
                            },
                            {
                                "name": "APPROVED NET - 1ST LIEN",
                                "table": "",
                                "column": "",
                                "type": "string"
                            },
                            {
                                "name": "DOES NET MATCH - 2ND LIEN",
                                "table": "",
                                "column": "",
                                "type": "string"
                            },
                            {
                                "name": "2ND MORTGAGE",
                                "table": "",
                                "column": "",
                                "type": "string"
                            },
                            {
                                "name": "APPROVED NET - 2ND LIEN",
                                "table": "",
                                "column": "",
                                "type": "string"
                            },
                            {
                                "name": "COMMISSION %",
                                "table": "",
                                "column": "",
                                "type": "string"
                            },
                            {
                                "name": "COMMISSION AMOUNT",
                                "table": "",
                                "column": "",
                                "type": "string"
                            },
                            {
                                "name": "TRANSFER TAX AMOUNT CORRECT",
                                "table": "",
                                "column": "",
                                "type": "string"
                            },
                            {
                                "name": "APPROVAL LETTER SAVED",
                                "table": "",
                                "column": "",
                                "type": "string"
                            },
                            {
                                "name": "CONFIRM OCCUPANCY",
                                "table": "",
                                "column": "",
                                "type": "string"
                            }
                          ]
                      }]
    }
]


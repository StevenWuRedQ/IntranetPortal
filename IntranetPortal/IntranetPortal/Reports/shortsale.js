[
  {
      "category": "Seller1",
      "fields": [
        {
            "name": "NAME",
            "table": "",
            "column": "",
            "type": "string"
        },
        {
            "name": "DOB",
            "table": "",
            "column": "",
            "type": "date"
        },
        {
            "name": "SSN",
            "table": "",
            "column": "",
            "type": "number"
        },
        {
            "name": "Mail Address",
            "table": "",
            "column": "",
            "type": "list",
            "options": ["1", "2", "3"]
        },
        {
            "name": "Cell #",
            "table": "",
            "column": "",
            "type": "boolean"
        },
        {
            "name": "Additional #",
            "table": "",
            "column": "",
            "type": "string"
        },
        {
            "name": "Email Address",
            "table": "",
            "column": "",
            "type": "string"
        },
         {
             "name": "BANKRUPTCY",
             "table": "",
             "column": "",
             "type": "boolean"
         },
        {
            "name": "BANK ACCOUNT",
            "table": "",
            "column": "",
            "type": "boolean"

        },
        {
            "name": "TAX RETURNS",
            "table": "",
            "column": "",
            "type": "boolean"
        },
        {
            "name": "EMPLOYED",
            "table": "",
            "column": "",
            "type": "string"
        },
        {
            "name": "PAYSTUBS",
            "table": "",
            "column": "",
            "type": "boolean"
        }
      ]
  },
  {
      "category": "Seller2",
      "fields": [
        {
            "name": "NAME",
            "table": "",
            "column": "",
            "type": "string"
        },
        {
            "name": "DOB",
            "table": "",
            "column": "",
            "type": "date"
        },
        {
            "name": "SSN",
            "table": "",
            "column": "",
            "type": "string"
        },
        {
            "name": "Mail Address",
            "table": "",
            "column": "",
            "type": "string"
        },
        {
            "name": "Cell #",
            "table": "",
            "column": "",
            "type": "string"
        },
        {
            "name": "Additional #",
            "table": "",
            "column": "",
            "type": "string"
        },
        {
            "name": "Email Address",
            "table": "",
            "column": "",
            "type": "string"
        },
         {
             "name": "BANKRUPTCY",
             "table": "",
             "column": "",
             "type": "boolean"
         },
        {
            "name": "BANK ACCOUNT",
            "table": "",
            "column": "",
            "type": "boolean"

        },
        {
            "name": "TAX RETURNS",
            "table": "",
            "column": "",
            "type": "boolean"
        },
        {
            "name": "EMPLOYED",
            "table": "",
            "column": "",
            "type": "string"
        },
        {
            "name": "PAYSTUBS",
            "table": "",
            "column": "",
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
            "table": "PropertyFloors",
            "column": "FloorId",
            "type": "number"
        },
        {
            "name": "Description",
            "table": "PropertyFloors",
            "column": "Desciprtion",
            "type": "string"
        }, {
            "name": "Bedroom",
            "table": "PropertyFloors",
            "column": "Bedroom",
            "type": "number"
        }, {
            "name": "Bathroom",
            "table": "PropertyFloors",
            "column": "Bathroom",
            "type": "number"
        }, {
            "name": "Livingroom",
            "table": "PropertyFloors",
            "column": "Livingroom",
            "type": "number"
        }, {
            "name": "Diningroom",
            "table": "PropertyFloors",
            "column": "Diningroom",
            "type": "number"

        }, {
            "name": "Occupied",
            "table": "PropertyFloors",
            "column": "Occupied",
            "type": "list",
            "options": ["Vacant", "Seller", "Tenants (Coop)", "Tenants (Non-Coop)"]

        }, {
            "name": "Access",
            "table": "PropertyFloors",
            "column": "Access",
            "type": "string"

        }, {
            "name": "LockBox",
            "table": "PropertyFloors",
            "column": "LockBox",
            "type": "string"

        }, {
            "name": "LockupDate",
            "table": "PropertyFloors",
            "column": "LockupDate",
            "type": "date"

        }, {
            "name": "LockedBy",
            "table": "PropertyFloors",
            "column": "LockedBy",
            "type": "string"

        }, {
            "name": "LastChecked",
            "table": "PropertyFloors",
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
            "name": "AUCTION DATE",
            "table": "",
            "column": "",
            "type": "boolean"
        },
        {
            "name": "DATE OF SALE",
            "table": "",
            "column": "",
            "type": "date"
        },
        {
            "name": "DATE VERIFIED",
            "table": "",
            "column": "",
            "type": "date"
        },
        {
            "name": "PAYOFF REQUESTED",
            "table": "",
            "column": "",
            "type": "date"
        },
        {
            "name": "PAYOFF EXPIRES",
            "table": "",
            "column": "",
            "type": "date"
        },
        {
            "name": "PAYOFF AMOUNT",
            "table": "",
            "column": "",
            "type": "number"
        }
      ]
  },
  {
      "category": "Mortgage 2",
      "fields": [
        {
            "name": "AUCTION DATE",
            "table": "",
            "column": "",
            "type": "boolean"
        },
        {
            "name": "DATE OF SALE",
            "table": "",
            "column": "",
            "type": "date"
        },
        {
            "name": "DATE VERIFIED",
            "table": "",
            "column": "",
            "type": "date"
        },
        {
            "name": "PAYOFF REQUESTED",
            "table": "",
            "column": "",
            "type": "date"
        },
        {
            "name": "PAYOFF EXPIRES",
            "table": "",
            "column": "",
            "type": "date"
        },
        {
            "name": "PAYOFF AMOUNT",
            "table": "",
            "column": "",
            "type": "number"
        }
      ]
  },
  {
      "category": "FORECLOSURE ATTORNEY",
      "fields": [
        {
            "name": "FORECLOSURE ATTORNEY",
            "table": "",
            "column": "",
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
      "category": "MORTGAGE COMPANY",
      "fields": [
        {
            "name": "MORTGAGE COMPANY",
            "table": "",
            "column": "",
            "type": "list"
        },
        {
            "name": "CATEGORY",
            "table": "",
            "column": "",
            "type": "address"
        },
        {
            "name": "STATUS",
            "table": "",
            "column": "",
            "type": "date"
        },
        {
            "name": "LOAN #",
            "table": "",
            "column": "",
            "type": "date"
        },
        {
            "name": "LOAN AMOUNT",
            "table": "",
            "column": "",
            "type": "number"
        },
        {
            "name": "LAST PAYMENT DATE",
            "table": "",
            "column": "",
            "type": "number"
        },
        {
            "name": "MORTGAGE TYPE",
            "table": "",
            "column": "",
            "type": "number"
        },
        {
            "name": "AUTHORIZATION SENT",
            "table": "",
            "column": "",
            "type": "number"
        },
        {
            "name": "CANCELATION SENT",
            "table": "",
            "column": "",
            "type": "number"
        },
        {
            "name": "SHORT SALE DEPT",
            "table": "",
            "column": "",
            "type": "number"
        },
        {
            "name": "CUSTOMER SERVICE #",
            "table": "",
            "column": "",
            "type": "number"
        },
        {
            "name": "SHORT SALE FAX #",
            "table": "",
            "column": "",
            "type": "number"
        }
      ]
  },
  {
      "category": "TITLE",
      "fields": [
        {
            "name": "COMPANY",
            "table": "",
            "column": "",
            "type": "string"
        },
        {
            "name": "TITLE #",
            "table": "",
            "column": "",
            "type": "string"
        },
        {
            "name": "REVIEWED",
            "table": "",
            "column": "",
            "type": "string"
        },
        {
            "name": "ORDER DATE",
            "table": "",
            "column": "",
            "type": "string"
        },
        {
            "name": "CONFIRMATION DATE",
            "table": "",
            "column": "",
            "type": "string"
        },
        {
            "name": "RECEIVED DATE",
            "table": "",
            "column": "",
            "type": "string"
        }
      ]
  },
  {
      "category": "LISTING INFO",
      "fields": [
        {
            "name": "MLS",
            "table": "",
            "column": "",
            "type": "string"
        },
        {
            "name": "MLS #",
            "table": "",
            "column": "",
            "type": "string"
        },
        {
            "name": "LIST PRICE",
            "table": "",
            "column": "",
            "type": "string"
        },
        {
            "name": "LISTING DATE",
            "table": "",
            "column": "",
            "type": "string"
        },
        {
            "name": "LISTING EXPIRY DATE",
            "table": "",
            "column": "",
            "type": "string"
        }
      ]
  },
  {
      "category": "VALUATIONS",
      "fields": [
        {
            "name": "Valuation",
            "table": "",
            "column": "",
            "type": "string"
        }
      ]
  },
  {
      "category": "OFFERS",
      "fields": [
        {
            "name": "OFFERS",
            "table": "",
            "column": "",
            "type": "string"
        }
      ]
  },
  {
      "category": "ASSIGNED PROCESSOR",
      "fields": [
        {
            "name": "NAME",
            "table": "",
            "column": "",
            "type": "string"
        },
        {
            "name": "PHONE #",
            "table": "",
            "column": "",
            "type": "string"
        },
        {
            "name": "EMAIL",
            "table": "",
            "column": "",
            "type": "string"
        }


      ]
  },
  {
      "category": "REFERRAL",
      "fields": [
        {
            "name": "AGENT",
            "table": "",
            "column": "",
            "type": "string"
        },
        {
            "name": "AGENT CELL #",
            "table": "",
            "column": "",
            "type": "string"
        },
        {
            "name": "AGENT EMAIL",
            "table": "",
            "column": "",
            "type": "string"
        },
        {
            "name": "TEAM",
            "table": "",
            "column": "",
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
            "name": "MANAGER",
            "table": "",
            "column": "",
            "type": "string"
        },
        {
            "name": "MANAGER CELL #",
            "table": "",
            "column": "",
            "type": "string"
        },
        {
            "name": "MANAGER EMAIL",
            "table": "",
            "column": "",
            "type": "string"
        },
        {
            "name": "ASSISTANT",
            "table": "",
            "column": "",
            "type": "string"
        },
        {
            "name": "ASSISTANT CELL #",
            "table": "",
            "column": "",
            "type": "string"
        },
        {
            "name": "ASSISTANT EMAIL",
            "table": "",
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
            "table": "",
            "column": "",
            "type": "string"
        },
        {
            "name": "CELL #",
            "table": "",
            "column": "",
            "type": "string"
        },
        {
            "name": "EMAIL",
            "table": "",
            "column": "",
            "type": "string"
        },
        {
            "name": "BROKER",
            "table": "",
            "column": "",
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
        }
      ]
  },
  {
      "category": "LISTING AGENT",
      "fields": [
        {
            "name": "NAME",
            "table": "",
            "column": "",
            "type": "string"
        },
        {
            "name": "CELL #",
            "table": "",
            "column": "",
            "type": "string"
        },
        {
            "name": "EMAIL",
            "table": "",
            "column": "",
            "type": "string"
        },
        {
            "name": "BROKER",
            "table": "",
            "column": "",
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
        }
      ]
  },
  {
      "category": "SELLER ATTORNEY",
      "fields": [
        {
            "name": "NAME",
            "table": "",
            "column": "",
            "type": "string"
        },
        {
            "name": "CELL #",
            "table": "",
            "column": "",
            "type": "string"
        },
        {
            "name": "EMAIL",
            "table": "",
            "column": "",
            "type": "string"
        },
        {
            "name": "OFFICE",
            "table": "",
            "column": "",
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
        }
      ]
  },
  {
      "category": "BUYER",
      "fields": [
        {
            "name": "ENTITY",
            "table": "",
            "column": "",
            "type": "string"
        },
        {
            "name": "ENTITY ADDRESS",
            "table": "",
            "column": "",
            "type": "string"
        },
        {
            "name": "SIGNOR",
            "table": "",
            "column": "",
            "type": "string"
        },
        {
            "name": "DATE OPENED",
            "table": "",
            "column": "",
            "type": "string"
        },
        {
            "name": "OFFICE",
            "table": "",
            "column": "",
            "type": "string"
        },
        {
            "name": "TAX ID",
            "table": "",
            "column": "",
            "type": "string"
        }
      ]
  },
  {
      "category": "BUYER ATTORNEY",
      "fields": [
        {
            "name": "NAME",
            "table": "",
            "column": "",
            "type": "string"
        },
        {
            "name": "CELL #",
            "table": "",
            "column": "",
            "type": "string"
        },
        {
            "name": "EMAIL",
            "table": "",
            "column": "",
            "type": "string"
        },
        {
            "name": "OFFICE",
            "table": "",
            "column": "",
            "type": "string"
        },
        {
            "name": "OFFICE ADDRESS",
            "table": "",
            "column": "",
            "type": "string"
        },
        {
            "name": "OFFICE #",
            "table": "",
            "column": "",
            "type": "string"
        }
      ]
  },
  {
      "category": "TITLE COMPANY",
      "fields": [
        {
            "name": "COMPANY",
            "table": "",
            "column": "",
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
            "name": "REP",
            "table": "",
            "column": "",
            "type": "string"
        },
        {
            "name": "REP #",
            "table": "",
            "column": "",
            "type": "string"
        },
        {
            "name": "EMAIL",
            "table": "",
            "column": "",
            "type": "string"
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
  }
]
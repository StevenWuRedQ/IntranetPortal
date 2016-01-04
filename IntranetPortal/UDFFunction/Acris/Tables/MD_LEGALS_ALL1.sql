CREATE TABLE [Acris].[MD_LEGALS_ALL1] (
    [DOCUMENT ID]         VARCHAR (16) NOT NULL,
    [BBLE]                VARCHAR (11) NOT NULL,
    [RECORD TYPE]         VARCHAR (1)  NULL,
    [BOROUGH]             VARCHAR (1)  NOT NULL,
    [BLOCK]               VARCHAR (5)  NOT NULL,
    [LOT]                 VARCHAR (4)  NOT NULL,
    [EASEMENT]            VARCHAR (1)  NOT NULL,
    [PARTIAL LOT]         VARCHAR (1)  NULL,
    [AIR RIGHTS]          VARCHAR (1)  NULL,
    [SUBTERRANEAN RIGHTS] VARCHAR (1)  NULL,
    [PROPERTY TYPE]       VARCHAR (2)  NULL,
    [STREET NUMBER]       VARCHAR (15) NULL,
    [STREET NAME]         VARCHAR (50) NULL,
    [UNIT]                VARCHAR (15) NULL,
    [GOOD THROUGH DATE]   DATETIME     NULL,
    [LastUpdated]         DATETIME     NULL,
    [CreatedOn]           DATETIME     NOT NULL
);


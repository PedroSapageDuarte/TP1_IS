USE [Contabilidade]
GO

/** Object:  Table [dbo].[Custos_Peca]    Script Date: 26/03/2025 14:49:43 **/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Custos_Peca](
    [ID_Custo] [int] IDENTITY(1,1) NOT NULL,
    [ID_Produto] [int] NOT NULL,
    [Codigo_Peca] [char](8) NOT NULL,
    [Tempo_Producao] [int] NOT NULL,
    [Custo_Producao] [decimal](10, 2) NOT NULL,
    [Lucro] [decimal](10, 2) NOT NULL,
    [Prejuizo] [decimal](10, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
    [ID_Custo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

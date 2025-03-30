USE [Producao]
GO
/****** Object:  StoredProcedure [dbo].[SP_InserirPecas]    Script Date: 30/03/2025 11:48:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Declaração da SP
ALTER PROCEDURE [dbo].[SP_InserirPecas]
    @codigoPeca CHAR(8),
    @dataProducao DATE,
    @horaProducao TIME,
    @tempoProducao INT,
    @codigoResultado CHAR(2),
    @dataTeste DATE           
AS
BEGIN
	--Verificar se já existe uma peça com o código atual e interrompe a inserção (caso haja)
    IF EXISTS (SELECT 1 FROM Produto WHERE Codigo_Peca = @codigoPeca)
    BEGIN
        RAISERROR ('Produto com este código já existe já existe.', 16, 1);
        RETURN;
    END

	--Caso contrário, inserir peça na tabela "Produto" com os respetivos valores
    INSERT INTO Produto (Codigo_Peca, Data_Producao, Hora_Producao, Tempo_Producao)
    VALUES (@CodigoPeca, @DataProducao, @HoraProducao, @TempoProducao);
    
    --Recupera o ID do produto recém-inserido
    DECLARE @NovoID INT;
    SET @NovoID = SCOPE_IDENTITY(); --Retorna o ID do último ID inserido na tabela
    
    --Se não for informado o código do teste, define como "06" (Desconhecido)
    IF (@codigoResultado IS NULL)
        SET @codigoResultado = '06';
    
    --Se não for informada a data do teste, usar a data atual
    IF (@dataTeste IS NULL)
        SET @dataTeste = CONVERT(DATE, GETDATE());
    
    --Inserir o registo do teste na tabela Testes
    INSERT INTO Testes (ID_Produto, Codigo_Resultado, Data_Teste)
    VALUES (@NovoID, @codigoResultado, @dataTeste);
    
    SELECT @NovoID AS ProdutoID, 'Inserção realizada com sucesso' AS Mensagem;
END

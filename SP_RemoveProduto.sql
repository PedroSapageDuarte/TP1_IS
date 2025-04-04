USE [Producao]
GO
/****** Object:  StoredProcedure [dbo].[SP_RemoveProduto]    Script Date: 30/03/2025 11:53:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Declaração da SP
ALTER PROCEDURE [dbo].[SP_RemoveProduto]
    @id_Produto INT
AS
BEGIN    
    SET NOCOUNT ON;
    
    --Verifica se o produto existe
    IF NOT EXISTS (SELECT 1 FROM Produto WHERE ID_Produto = @id_Produto)
    BEGIN
        RAISERROR ('Produto não encontrado.', 16, 1);
        RETURN;
    END
    
    --Remove os registros dependentes em Testes
    DELETE FROM Testes WHERE ID_Produto = @id_Produto;
    
    --Remove o registro na tabela Custos_Peca na base Contabilidade
    DELETE FROM Contabilidade.dbo.Custos_Peca WHERE ID_Produto = @id_Produto;
    
    --Remove o produto na tabela Produto
    DELETE FROM Produto WHERE ID_Produto = @id_Produto;
    
    SELECT 'Produto, Testes e Custos removidos com sucesso' AS Mensagem;
END;

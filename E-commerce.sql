-- Tabelas
CREATE TABLE Cliente (
    ClienteID INT PRIMARY KEY,
    Nome VARCHAR(100),
    Email VARCHAR(100),
    Tipo VARCHAR(2) -- PF ou PJ
);

CREATE TABLE Conta (
    ContaID INT PRIMARY KEY,
    ClienteID INT,
    NumeroConta VARCHAR(20),
    Saldo DECIMAL(10, 2),
    FOREIGN KEY (ClienteID) REFERENCES Cliente(ClienteID)
);

CREATE TABLE Pagamento (
    PagamentoID INT PRIMARY KEY,
    PedidoID INT,
    FormaPagamento VARCHAR(50),
    FOREIGN KEY (PedidoID) REFERENCES Pedido(PedidoID)
);

CREATE TABLE Pedido (
    PedidoID INT PRIMARY KEY,
    ClienteID INT,
    DataPedido DATE,
    Status VARCHAR(20),
    FOREIGN KEY (ClienteID) REFERENCES Cliente(ClienteID)
);

CREATE TABLE Produto (
    ProdutoID INT PRIMARY KEY,
    Nome VARCHAR(100),
    Preco DECIMAL(10, 2)
);

CREATE TABLE Estoque (
    EstoqueID INT PRIMARY KEY,
    ProdutoID INT,
    Quantidade INT,
    FOREIGN KEY (ProdutoID) REFERENCES Produto(ProdutoID)
);

CREATE TABLE Fornecedor (
    FornecedorID INT PRIMARY KEY,
    Nome VARCHAR(100),
    Email VARCHAR(100)
);

CREATE TABLE ProdutoFornecedor (
    ProdutoID INT,
    FornecedorID INT,
    PRIMARY KEY (ProdutoID, FornecedorID),
    FOREIGN KEY (ProdutoID) REFERENCES Produto(ProdutoID),
    FOREIGN KEY (FornecedorID) REFERENCES Fornecedor(FornecedorID)
);

CREATE TABLE Entrega (
    EntregaID INT PRIMARY KEY,
    PedidoID INT,
    Status VARCHAR(20),
    CodigoRastreio VARCHAR(50),
    FOREIGN KEY (PedidoID) REFERENCES Pedido(PedidoID)
);

-- Recuperação de clientes:
SELECT * FROM Cliente;

-- Filtragem de pedidos por status:
SELECT * FROM Pedido WHERE Status = 'Entregue';

-- Total de compras de cada cliente:
SELECT c.Nome, COUNT(p.PedidoID) AS TotalCompras
FROM Cliente c
LEFT JOIN Pedido p ON c.ClienteID = p.ClienteID
GROUP BY c.Nome;

-- Ordenar produtos por preço:
SELECT * FROM Produto ORDER BY Preco DESC;

-- Filtro e ordenação de Fornecedores por nome:
SELECT * FROM Fornecedor WHERE Nome LIKE 'A%' ORDER BY Nome;

-- Relação entre produtos, fornecedores e estoque:
SELECT p.Nome AS Produto, f.Nome AS Fornecedor, e.Quantidade AS Estoque
FROM Produto p
INNER JOIN ProdutoFornecedor pf ON p.ProdutoID = pf.ProdutoID
INNER JOIN Fornecedor f ON pf.FornecedorID = f.FornecedorID
INNER JOIN Estoque e ON p.ProdutoID = e.ProdutoID;

-- Pedidos feitos para cada cliente:
SELECT c.Nome AS Cliente, COUNT(p.PedidoID) AS TotalPedidos
FROM Cliente c
LEFT JOIN Pedido p ON c.ClienteID = p.ClienteID
GROUP BY c.Nome;

-- Vendedores que são fornecedores:
SELECT c.Nome AS VendedorFornecedor
FROM Cliente c
INNER JOIN ProdutoFornecedor pf ON c.ClienteID = pf.FornecedorID
WHERE c.Tipo = 'PJ';

-- Relação de produtos, fornecedores e estoques com estoque disponível:
SELECT p.Nome AS Produto, f.Nome AS Fornecedor, e.Quantidade AS EstoqueDisponivel
FROM Produto p
INNER JOIN ProdutoFornecedor pf ON p.ProdutoID = pf.ProdutoID
INNER JOIN Fornecedor f ON pf.FornecedorID = f.FornecedorID
INNER JOIN Estoque e ON p.ProdutoID = e.ProdutoID
WHERE e.Quantidade > 0;

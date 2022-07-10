-- Clientes dependientes
SELECT t.numero AS 'Conta', c.nome AS 'Dependente', (
	SELECT c.nome AS 'Titutar'
	FROM cliente AS c, cliente_conta AS cc
	WHERE cc.id_cliente = c.id AND
          ccc.id_conta = cc.id_conta AND
          cc.dependente = 0) AS 'Titular'
FROM cliente AS c, cliente_conta AS ccc, cliente_conta AS cc, conta t
WHERE cc.id_cliente = c.id AND
      ccc.id_conta = cc.id_conta AND
      t.id = cc.id_conta AND
      cc.dependente = 1
      GROUP BY c.nome;

-- Bottom five das contas com menos transacoes
SELECT  c.numero AS 'Conta', count(*) AS 'Total transações'
FROM transacao t
INNER JOIN cliente_conta cc
ON cc.id = t.id_cliente_conta
INNER JOIN conta c
ON c.id = cc.id_conta
GROUP BY c.numero
ORDER BY "Total transações" asc limit 5;

-- Top five das contas com mais transacoes
SELECT  c.numero AS 'Conta', count(*) AS 'Total transações'
FROM transacao t
INNER JOIN cliente_conta cc
ON cc.id = t.id_cliente_conta
INNER JOIN conta c
ON c.id = cc.id_conta
GROUP BY c.numero
ORDER BY "Total transações" DESC LIMIT 5;

-- Saldo total em contas do Banco
SELECT c.numero AS 'Conta Numero', 
       SUM(CASE WHEN t.id_tipo_transacao = 1 THEN t.valor ELSE 0 END) AS 'Total Entradas',
       SUM(CASE WHEN t.id_tipo_transacao != 1 THEN t.valor ELSE 0 END) AS 'Total Saídas',
       (SUM(CASE WHEN t.id_tipo_transacao = 1 THEN t.valor ELSE 0 END) -
       SUM(CASE WHEN t.id_tipo_transacao != 1 THEN t.valor ELSE 0 END) ) AS 'Saldo Total em Conta'
FROM transacao t
INNER JOIN cliente_conta cc
ON cc.id = t.id_cliente_conta
INNER JOIN conta c
ON c.id = cc.id_conta
GROUP BY c.numero;


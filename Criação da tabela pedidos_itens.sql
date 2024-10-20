CREATE TABLE IF NOT EXISTS pedidos_itens(
	id INT NOT NULL AUTO_INCREMENT,
	pedido_id INT NOT NULL,
	produto_id INT NOT NULL,
	quantidade DECIMAL(9,3) NOT NULL DEFAULT 0,
	CONSTRAINT cp_pedidos_itens PRIMARY KEY (id),
	CONSTRAINT ce_pedidos_itens__pedido_id FOREIGN KEY (pedido_id) REFERENCES pedidos(id),
	CONSTRAINT ce_pedidos_itens__produto_id FOREIGN KEY (produto_id) REFERENCES produtos(id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

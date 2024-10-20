CREATE TABLE IF NOT EXISTS produtos(
	id INT NOT NULL AUTO_INCREMENT,
	nome VARCHAR(300) NOT NULL DEFAULT '',
	estoque DECIMAL(9,3) NOT NULL DEFAULT 0,
	CONSTRAINT cp_produtos PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
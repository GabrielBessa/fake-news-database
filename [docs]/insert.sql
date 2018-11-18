-- usuarios
INSERT INTO usuario (usuario_name)
    VALUES ('Kletion');
INSERT INTO usuario (usuario_name)
    VALUES ('Jose');
INSERT INTO usuario (usuario_name)
    VALUES ('Mary');
INSERT INTO usuario (usuario_name)
    VALUES ('Role');
INSERT INTO usuario (usuario_name)
    VALUES ('Leron');
INSERT INTO usuario (usuario_name)
    VALUES ('John');
INSERT INTO usuario (usuario_name)
    VALUES ('Amanda');
INSERT INTO usuario (usuario_name)
    VALUES ('Anne');
INSERT INTO usuario (usuario_name)
    VALUES ('David');
INSERT INTO usuario (usuario_name)
    VALUES ('Gious');
-- company
INSERT INTO company (company_name)
    VALUES ('Folha de São Paulo');
INSERT INTO company (company_name)
    VALUES ('UOL');
INSERT INTO company (company_name)
    VALUES ('Globo');
INSERT INTO company (company_name)
    VALUES ('Folha de Alphaville');
INSERT INTO company (company_name)
    VALUES ('Gazeta do litoral');
INSERT INTO company (company_name)
    VALUES ('Correio brasiliense');
INSERT INTO company (company_name)
    VALUES ('Parana Portal');
INSERT INTO company (company_name)
    VALUES ('SBT');
INSERT INTO company (company_name)
    VALUES ('Record');
INSERT INTO company (company_name)
    VALUES ('Rede_Tv');
INSERT INTO company (company_name)
    VALUES ('Tribuna do Ceará');
-- government power
INSERT INTO government_power (government_power_name)
    VALUES ('Executivo');
INSERT INTO government_power (government_power_name)
    VALUES ('Legislativo');
-- metodo de propagação
INSERT INTO propagation_method (propagation_method_name)
    VALUES ('Whatsapp');
INSERT INTO propagation_method (propagation_method_name)
    VALUES ('Telegram');
INSERT INTO propagation_method (propagation_method_name)
    VALUES ('Facebook');
INSERT INTO propagation_method (propagation_method_name)
    VALUES ('Twitter');
-- tipo de penalidade
INSERT INTO penalty_type (penalty_type_name)
    VALUES ('Difamacao de Imagem');
INSERT INTO penalty_type (penalty_type_name)
    VALUES ('Danos Morais');
-- tipo de extensao
INSERT INTO extensao (extensao_name)
    VALUES ('jpg');
INSERT INTO extensao (extensao_name)
    VALUES ('mp4');
-- fake news propagation method
INSERT INTO fake_news_propagation_method(propagation_method_id, fake_news_id)
	VALUES(1,1);
INSERT INTO fake_news_propagation_method(propagation_method_id, fake_news_id)
	VALUES(2,4);
INSERT INTO fake_news_propagation_method(propagation_method_id, fake_news_id)
	VALUES(3,3);
INSERT INTO fake_news_propagation_method(propagation_method_id, fake_news_id)
	VALUES(4,2);
INSERT INTO fake_news_propagation_method(propagation_method_id, fake_news_id)
	VALUES(3,5);
INSERT INTO fake_news_propagation_method(propagation_method_id, fake_news_id)
	VALUES(1,6);
-- fake news type
INSERT INTO fake_news_type (fake_news_type_name)
    VALUES ('Conteudo_enganoso');
INSERT INTO fake_news_type (fake_news_type_name)
    VALUES ('Falso_contexto');
INSERT INTO fake_news_type (fake_news_type_name)
    VALUES ('Conteudo_impostor'); 
INSERT INTO fake_news_type (fake_news_type_name)
    VALUES ('Falsa_conexao'); 
INSERT INTO fake_news_type (fake_news_type_name)
    VALUES ('Conteudo_manipulado'); 
INSERT INTO fake_news_type (fake_news_type_name)
    VALUES ('Conteudo_fabricado'); 

-- fake news
INSERT INTO fake_news (fake_news_title, fake_news_content, fake_news_intention, company_id, 
                        government_power_id, fake_news_type_id)
    VALUES('Bolsonaro mata Alan Turing, homossexual e ateu, pai da ciencia da computação',
           'blah', FALSE, 3, 1, 5);
INSERT INTO fake_news (fake_news_title, fake_news_content, fake_news_intention, company_id, 
                        government_power_id, fake_news_type_id)
    VALUES('Campanha pro bolsonaro não tem nenhum apoio em manifestações',
           'blah', FALSE, 3, 2, 1);
INSERT INTO fake_news (fake_news_title, fake_news_content, fake_news_intention, company_id, 
                        government_power_id, fake_news_type_id)
    VALUES('Foi comprovado que Haddad iria desviar dinheiro e acabar com a lava jato',
           'blah', FALSE, 2, 1, 1);
INSERT INTO fake_news (fake_news_title, fake_news_content, fake_news_intention, company_id, 
                        government_power_id, fake_news_type_id)
    VALUES('Haddad nasceu com quatro braços e três pernas',
           'blah', FALSE, 2, 2, 5);
INSERT INTO fake_news (fake_news_title, fake_news_content, fake_news_intention, company_id, 
                        government_power_id, fake_news_type_id)
    VALUES('A candidata a presidência Marina foi vista brincando com dinossauros em seu quintal',
           'blah', FALSE, 9, 1, 5);
INSERT INTO fake_news (fake_news_title, fake_news_content, fake_news_intention, company_id, 
                        government_power_id, fake_news_type_id)
    VALUES('O Candidato Cabo Daciolo foi visto beijando Ciro Gomes',
           'blah', FALSE, 9, 1, 1);
-- fake news usuario
INSERT INTO fake_news_usuario (usuario_id, fake_news_id)
    VALUES(3, 7);
-- arquivo
INSERT INTO arquivo (extensao_id,arquivo_name,fake_news_id,arquivo_content )VALUES(1,7,lo_import('C:\Users\tvmma\Desktop\eu.png'))
-- procedure
$$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION get_extension_id(name VARCHAR(50))
RETURNS INT AS $$
DECLARE
    extension_id INT;                                    
BEGIN
    SELECT extensao.extensao_id INTO extension_id  FROM extensao  WHERE extensao.extensao_name = name;  
    RETURN extension_id;                                                         
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insert_file_db(extensao_id INT, arquivo_name VARCHAR(50), fake_news_id INT, arquivo_path TEXT)
RETURNS void AS $$
BEGIN
    if(extensao_id IS NULL)then
        RAISE EXCEPTION 'Invalid extension type';
    elseif(fake_news_id IS NULL)then
        RAISE EXCEPTION 'Invalid fake_news_id type';
    else
        INSERT INTO arquivo(extensao_id, arquivo_name, fake_news_id,arquivo_content ) VALUES(extensao_id, arquivo_name, fake_news_id, lo_import(arquivo_path));
    end if;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_file_name(file_name VARCHAR(50), file_id INT)
RETURNS void AS $$
DECLARE
    extension_name VARCHAR(50);                                    
BEGIN
    SELECT extensao.extensao_name INTO extension_name  FROM extensao,arquivo  WHERE extensao.extensao_id = arquivo.extensao_id AND arquivo.arquivo_id = file_id;  
    extension_name =  file_name || '.' || split_part(extension_name, '/', 2);
    UPDATE arquivo SET arquivo_name = extension_name WHERE arquivo.arquivo_id = file_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_file_content(file_path VARCHAR(50), file_id INT)
RETURNS void AS $$
BEGIN
    UPDATE arquivo SET arquivo_content = lo_import(file_path) WHERE arquivo.arquivo_id = file_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_file(file_name VARCHAR(50), fake_news_id INT, file_path VARCHAR(50), file_id INT)
RETURNS void AS $$
BEGIN
    if(file_name IS NOT NULL)then
        PERFORM update_file_name(file_name, file_id);
    elseif (file_path IS NOT NULL)then
        PERFORM update_file_content(file_path, file_id);
    end if;
END;
$$ LANGUAGE plpgsql;



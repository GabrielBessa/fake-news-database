module.exports = {
    erase_files: function(path) {
		var rimraf = require('rimraf');
		// erase all files inside this folder
		path = path + '*';

		rimraf(path,() => { });
	},
    get_all_files: function(connection, callback)  {
	    // SQL query
	    const query = {
	        text: 'SELECT arquivo.arquivo_id AS file_id, arquivo.arquivo_name AS name, extensao.extensao_name AS extension, fake_news.fake_news_title, fake_news.fake_news_id ' +
	              'FROM arquivo, extensao, fake_news ' +
	              'WHERE (arquivo.extensao_id = extensao.extensao_id AND fake_news.fake_news_id = arquivo.fake_news_id)'
	    };

	    // callback
	    connection.query(query, callback);
	},
	get_list_to_insert_fake_news: function(connection,  callback)  {
	    // SQL query
	    const query = {
	        text: 'SELECT DISTINCT company_name,parties_name,government_power_name,fake_news_type_name ' +
	              'FROM company, parties, government_power, fake_news_type'
	    };

	    // callback
	    connection.query(query, callback);
	},
	get_all_news: function(connection, callback){
		// SQL query
	    const query = {
	        text: 'SELECT fake_news.fake_news_id AS id, fake_news.fake_news_title AS title, fake_news.fake_news_content AS content, fake_news.fake_news_intention AS intention, get_company_name(fake_news.company_id) AS company, get_government_power_name(fake_news.government_power_id) AS government_power , get_fake_news_type_name(fake_news.fake_news_type_id) AS type, politycal_parties_relation.parties ' +
	              'FROM politycal_parties_relation,fake_news ' +
	              'WHERE fake_news.fake_news_id = politycal_parties_relation.fake_news_id ' +
	              'ORDER BY fake_news.fake_news_id'
	    };

	    // callback
	    connection.query(query, callback);
	},
	get_news_to_insert_file: function(connection, callback){
		// SQL query
	    const query = {
	        text: 'SELECT fake_news_id, fake_news_title FROM fake_news;'
	    };

	    // callback
	    connection.query(query, callback);
	},
	get_fake_news_data: function(connection, callback){
		// SQL query
	    const query = {
			text: 'SELECT array_agg((company_id,company_name))::text[] AS data FROM company UNION ALL ' +
			      'SELECT array_agg((government_power_id,government_power_name))::text[]  FROM government_power	UNION ALL ' +
			      'SELECT array_agg((parties_id,parties_name))::text[]  FROM parties UNION ALL ' + 
			      'SELECT array_agg((fake_news_type_id,fake_news_type_name))::text[]  FROM fake_news_type'	
	    };

	    // callback
	    connection.query(query, callback);
	}
};


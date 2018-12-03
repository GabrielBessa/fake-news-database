module.exports = (app) => {

	app.get('/penalty/list', (req,res) => {
		app.app.controllers.penalty.list(app, req, res);
	});

	app.get('/penalty/insert_form', (req,res) => {
		app.app.controllers.penalty.insert_form(app, req, res);
	});

	app.post('/penalty/upload', (req,res) => {
		app.app.controllers.penalty.upload(app, req, res);
	});

	app.post('/penalty/edit', (req,res) => {
		app.app.controllers.penalty.edit(app, req, res);
	});

	app.post('/penalty/delete', (req,res) => {
		app.app.controllers.penalty.delete(app, req, res);
	});

};

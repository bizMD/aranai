function create(__helpers) {
  var str = __helpers.s,
      empty = __helpers.e,
      notEmpty = __helpers.ne,
      escapeXml = __helpers.x,
      loadTemplate = __helpers.l,
      __searchBar = loadTemplate(require.resolve("./searchBar.marko")),
      __tableBody = loadTemplate(require.resolve("./tableBody.marko"));

  return function render(data, out) {
    out.w("<html> <head> <title>Aranai: Test Web Crawler</title> <link rel=\"stylesheet\" type=\"text/css\" href=\"/home/css\"> </head> <body> <section class=\"pageBody\"> <section class=\"searchBar full-width top-margin\"> ");

    __searchBar.render({}, out);

    out.w(" </section> <section class=\"tableBody full-width top-margin hidden\"> ");

    __tableBody.render({}, out);

    out.w(" </section> </section> <script src=\"/home/js\"></script> </body> </html>");
  };
}

(module.exports = require("marko").c(__filename)).c(create);

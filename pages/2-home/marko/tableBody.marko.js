function create(__helpers) {
  var str = __helpers.s,
      empty = __helpers.e,
      notEmpty = __helpers.ne,
      escapeXml = __helpers.x;

  return function render(data, out) {
    out.w("<table class=\"tables\"> <thead> <tr> <th>Page Title</th> <th>Link to Result</th> </tr> </thead> <tbody> </tbody> </table>");
  };
}

(module.exports = require("marko").c(__filename)).c(create);

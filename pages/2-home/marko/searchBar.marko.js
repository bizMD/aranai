function create(__helpers) {
  var str = __helpers.s,
      empty = __helpers.e,
      notEmpty = __helpers.ne,
      escapeXml = __helpers.x;

  return function render(data, out) {
    out.w("<form class=\"search-bar\" role=\"search\"> <input type=\"search\" placeholder=\"Enter Search\"> <button type=\"submit\"> <img src=\"https://raw.githubusercontent.com/thoughtbot/refills/master/source/images/search-icon-black.png\" alt=\"Search Icon\"> </button> </form>");
  };
}

(module.exports = require("marko").c(__filename)).c(create);

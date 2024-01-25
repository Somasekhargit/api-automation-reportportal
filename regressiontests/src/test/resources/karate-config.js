function fn() {

var env = karate.env;
var apikey = '0fiuZFh4';


  karate.log(" Tests are running in environment: ", env);

  var config = {
      host: 'https://www.rijksmuseum.nl',
      path: '/api/nl/collection/',
      path_en: '/api/en/collection/',
      apikey: '0fiuZFh4'
  }

//karate.configure('report', { showLog: true, showAllSteps: false, showCallArg: false });
 return config;
}
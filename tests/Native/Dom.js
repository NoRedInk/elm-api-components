
Elm.Native.Dom = {};
Elm.Native.Dom.make = function(localRuntime) {
    localRuntime.Native = localRuntime.Native || {};
    localRuntime.Native.Dom = localRuntime.Native.Dom || {};
    if (localRuntime.Native.Dom.values)
    {
        return localRuntime.Native.Dom.values;
    }

    $Elm$List = Elm.Native.List.make(localRuntime);
    $Elm$Task = Elm.Native.Task.make(localRuntime);

    var toHtml = require('vdom-to-html');
    var cheerio = require('cheerio');

    var toCheerio = function(html){
        return cheerio.load(html);
    };

    var find = function(query, cheerioInstance){
        var $ = cheerioInstance;

        var nodes = [];
        var found = cheerioInstance(query);

        for (var i = 0; i < found.length; i++){
            nodes.push(cheerio.load(found[i]));
        };

        return $Elm$List.fromArray(nodes);
    };

    return Elm.Native.Dom.values = {
        htmlToString: toHtml,
        stringToCheerio: toCheerio,
        find: F2(find)
    };
};

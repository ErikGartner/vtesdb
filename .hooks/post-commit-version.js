#!/usr/bin/env node
var exec = require('child_process').exec,
    Promise = require('promise'),
    path = require('path'),
    moment = require('moment'),
    util = require('util'),
    fs = require('fs'),
    contents = null,
    branch, commit;

function getBranch(){
    return new Promise(function (fulfill, reject){
        exec(
            "git branch | grep '*'",
            function (err, stdout, stderr) {
                if(err)reject(err)
                var name = stdout.replace('* ','').replace('\n','');
                fulfill(name)
            }
        )
    });
}

function getCommit(){
    return new Promise(function (fulfill, reject){
        exec(
            "git rev-parse HEAD",
            function (err, stdout, stderr) {
                if(err)reject(err)
                var commitName = stdout.replace('* ','').replace('\n','');
                fulfill(commitName)
            }
        )
    });
}

var result = {
    timestamp : moment().format("DD-MM-YYYY HH:mm")
};
console.log("path : "+ __dirname);

getBranch()
    .then(function(_branch){
        result.branch = _branch;
    })
    .then(getCommit)
    .then(function(_commit){
        result.commit = _commit;
    })
    .then(function(){
        var fileContent = JSON.stringify(result,null,2);

        var pathToFile = __dirname+"/../private/version.json";
        console.log("path normalized: "+ path.normalize(pathToFile));
        if (fs.existsSync(pathToFile)) {
            fs.writeFile(pathToFile, fileContent , function(err) {
                if(err) {
                    console.log(err);
                } else {
                    console.log("The file was saved!");
                }
            });
        }else{
            console.log("Cannot find file : " + pathToFile);
        }
    })

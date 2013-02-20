#!/usr/bin/env dart

import 'dart:io';

void main() {
  var directory = new Directory('.');
  var dartFilePaths = [];
  var lister = directory.list();
  lister.onFile = (path) {
    if (path.endsWith('.dart')) {
      dartFilePaths.add(path);
    }
  };
  lister.onDone = (completed) {
    var pathsToProcess = [];
    for (var path in dartFilePaths) {
      var contents = new File.fromPath(new Path(path)).readAsStringSync();
      // Regexp to check if there is something that looks like a main(). There
      // can be false-positives if there is a main() function commented out, for
      // example. Specifically, it looks for something of the form:
      //     main() {
      // with arbitrary whitespace.
      if (new RegExp(r'\bmain\s*\(\s*\)\s*{').hasMatch(contents)) {
        pathsToProcess.add(path);
      }
    }
    if (pathsToProcess.length > 0) {
      processFiles(pathsToProcess);
    } else {
      print('No files in this directory to process.');
    }
  };
}

// Run dart2js on every file passed in.
void processFiles(paths) {
  var i = 0;
  void processFile(path) {
    print('Processing $path');
    Process.start('dart2js', ['-o$path.js', path]).then((process) {
      process.stdout.pipe(stdout, close: false);
      process.stderr.pipe(stderr, close: false);
      process.onExit = (code) {
        if (++i < paths.length) {
          processFile(paths[i]);
        }
      };
    });
  }
  processFile(paths[0]);
}

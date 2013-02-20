#auto-dart2js

This will run dart2js on all the .dart files in the current directory which
contain a main() function definition. It names the output files with the same
filename with '.js' added to the end.

##Usage

* Have dart2js in your PATH.
* Put a symlink in a directory in your PATH that points to `auto-dart2js.dart`
    * Example: `ln -s ~/code/auto-dart2js/auto-dart2js.dart ~/bin/auto-dart2js`
* Run in whatever directory you want.

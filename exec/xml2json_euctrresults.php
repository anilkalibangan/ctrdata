<?php

// file: xml2json_euctrresults.php
// ralf.herold@gmx.net
// part of https://github.com/rfhb/ctrdata
// last edited: 2017-07-28
// time xml2json_euctrresults.php:
// 2017-07-30: 0.23 s for 3 trials ~ 75 ms per trial

// note line endings are to be kept by using in
// .gitattributes for compatibility with cygwin:
// *.sh  text eol=lf
// *.php text eol=lf

if ($argc <= 1) {
	die("Usage: php -n -f xml2json_euctrresults.php <directory_path_with_xml_files>\n");
} else {
	$testXmlFile = $argv[1];
}

file_exists($testXmlFile) or die('Directory or file does not exist: ' . $testXmlFile);

foreach (glob("$testXmlFile/[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9].xml") as $inFileName) {

  $outFileName = "$testXmlFile/" . basename($inFileName, '.xml') . '.json';

  $fileContents = file_get_contents($inFileName);

  // normalise contents and remove whitespace
  $fileContents = str_replace(array("\n", "\r", "\t"), '', $fileContents);

  // https://stackoverflow.com/questions/44765194/how-to-parse-invalid-bad-not-well-formed-xml
  $fileContents = preg_replace('/[^\x{0009}\x{000a}\x{000d}\x{0020}-\x{D7FF}\x{E000}-\x{FFFD}]+/u', ' ', $fileContents);

  // escapes
  $fileContents = preg_replace('/ +/', ' ', $fileContents);
  $fileContents = trim(str_replace("'", " &apos;", $fileContents));
  $fileContents = trim(str_replace("&", " &amp;", $fileContents));

  // use single escapes for xml
  $fileContents = trim(str_replace('"', "'", $fileContents));

  // turn repeat elements
  $simpleXml = simplexml_load_string($fileContents, 'SimpleXMLElement', LIBXML_COMPACT | LIBXML_NOBLANKS | LIBXML_NOENT);

  // save in file
  file_put_contents($outFileName, json_encode($simpleXml), LOCK_EX);

}

?>

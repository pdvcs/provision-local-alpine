package main

import (
	"fmt"
	"io/ioutil"
	"os"
	"strings"
)

func usage() {
	fmt.Println("tokrepl input output comma-delimited-tokens")
	fmt.Println("e.g.: tokrepl input.txt output.txt a=b,c=d,e=f")
	fmt.Println("\ntokrepl.go, Copyright (c) @pdutta 2016")
	os.Exit(1)
}

func fileExists(s string) bool {
	var exists bool = false
	if _, err := os.Stat(s); err == nil {
		exists = true
	}
	return exists
}

func readInputFile(fname string) (string, error) {
	data, err := ioutil.ReadFile(fname)
	if err != nil {
		data = nil
	}
	return string(data), err
}

func writeFileContents(outputfile, fcontents string) error {
	err := ioutil.WriteFile(outputfile, []byte(fcontents), 0644)
	if err != nil {
		fmt.Println(err)
	}
	return err
}

func main() {
	args := os.Args[1:]
	if len(args) != 3 || !fileExists(args[0]) {
		usage()
		os.Exit(1)
	}

	inputfile := args[0]
	outputfile := args[1]
	tokenlist := args[2]

	var tokens = strings.Split(tokenlist, ",")
	if len(tokens) < 1 {
		usage()
	}

	fcontents, err := readInputFile(inputfile)
	if err == nil {
		for _, token := range tokens {
			var kv = strings.Split(token, "=")
			if len(kv) != 2 {
				usage()
			}
			// fmt.Printf("# replacing %s with %s...\n", kv[0], kv[1])
			fcontents = strings.Replace(fcontents, kv[0], kv[1], -1)
		}
	}

	err = writeFileContents(outputfile, fcontents)
	if err == nil {
		fmt.Printf("Wrote '%s' to disk.\n", outputfile)
	}
}

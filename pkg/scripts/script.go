package scripts

import (
	"bufio"
	"fmt"
	"io"
	"log"
	"os/exec"
	"sync"
)

// ExecuteScript runs the specified script file and streams its output to the callback
func ExecuteScript(scriptPath string, callback func(string)) error {
	// Ensure the callback is not nil
	if callback == nil {
		return fmt.Errorf("callback cannot be nil")
	}

	// Create a command to execute the script
	cmd := exec.Command("bash", scriptPath)

	// Get the standard output and standard error pipes
	stdout, err := cmd.StdoutPipe()
	if err != nil {
		return err
	}
	stderr, err := cmd.StderrPipe()
	if err != nil {
		return err
	}

	// Start the command
	if err := cmd.Start(); err != nil {
		return err
	}

	// WaitGroup to handle both stdout and stderr streaming
	var wg sync.WaitGroup
	wg.Add(2)

	// Stream standard output
	go streamOutput(stdout, callback, &wg)

	// Stream standard error
	go streamOutput(stderr, callback, &wg)

	// Wait for both streaming routines to finish
	wg.Wait()

	// Wait for the command to finish
	if err := cmd.Wait(); err != nil {
		return err
	}

	return nil
}

// streamOutput reads output from the provided pipe and sends it to the callback
func streamOutput(pipe io.ReadCloser, callback func(string), wg *sync.WaitGroup) {
	defer wg.Done()
	scanner := bufio.NewScanner(pipe)
	for scanner.Scan() {
		callback(scanner.Text()) // Send each line of output to the callback
	}
	if err := scanner.Err(); err != nil {
		log.Printf("Error reading script output: %v", err)
	}
}

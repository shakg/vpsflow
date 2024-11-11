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
		return fmt.Errorf("failed to create stdout pipe: %w", err)
	}
	stderr, err := cmd.StderrPipe()
	if err != nil {
		return fmt.Errorf("failed to create stderr pipe: %w", err)
	}

	// Create a WaitGroup to handle both stdout and stderr streaming
	var wg sync.WaitGroup
	wg.Add(2)

	// Start the output streaming before starting the command
	go func() {
		streamOutput(stdout, callback, &wg)
	}()
	go func() {
		streamOutput(stderr, callback, &wg)
	}()

	// Start the command after setting up the output streaming
	if err := cmd.Start(); err != nil {
		return fmt.Errorf("failed to start command: %w", err)
	}

	// Create a channel to handle errors from streamOutput
	errChan := make(chan error, 1)

	// Wait for streaming to complete in a separate goroutine
	go func() {
		wg.Wait()
		close(errChan)
	}()

	// Wait for the command to complete
	cmdErr := cmd.Wait()

	// Wait for streaming to complete or timeout
	if streamErr := <-errChan; streamErr != nil {
		return fmt.Errorf("error streaming output: %w", streamErr)
	}

	// Return any error from the command execution
	if cmdErr != nil {
		return fmt.Errorf("command execution failed: %w", cmdErr)
	}

	return nil
}

// streamOutput reads output from the provided pipe and sends it to the callback
func streamOutput(pipe io.ReadCloser, callback func(string), wg *sync.WaitGroup) {
	defer wg.Done()
	defer pipe.Close()

	scanner := bufio.NewScanner(pipe)
	for scanner.Scan() {
		callback(scanner.Text()) // Send each line of output to the callback
	}

	if err := scanner.Err(); err != nil {
		log.Printf("Error reading script output: %v", err)
	}
}

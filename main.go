package main

import (
	"flag"
	"fmt"
	"github.com/derphilipp/gomar/version"
	ui "github.com/gizak/termui/v3"
	"github.com/gizak/termui/v3/widgets"
	"log"
)

// Config is the configuration for gomar
type Config struct {
	MarblesPerDay int
}

var cfg = &Config{16}

// Event is a marble-even within a day
type Event struct {
	Change      int
	Description string
}

// Day describes a whole day, consisting of marble-events
type Day struct {
	Events []Event
}

func printVersionInfo() {
	fmt.Println("Build Date:", version.BuildDate)
	fmt.Println("Git Commit:", version.GitCommit)
	fmt.Println("Version:", version.Version)
	fmt.Println("Go Version:", version.GoVersion)
	fmt.Println("OS / Arch:", version.OsArch)
}

func main() {
	versionFlag := flag.Bool("version", false, "Version")
	flag.Parse()
	if *versionFlag {
		printVersionInfo()
		return
	}

	if err := ui.Init(); err != nil {
		log.Fatalf("failed to initialize termui: %v", err)
	}
	defer ui.Close()

	p := widgets.NewParagraph()
	p.Text = "Hello World!"
	p.SetRect(0, 0, 25, 5)

	ui.Render(p)

	for e := range ui.PollEvents() {
		if e.Type == ui.KeyboardEvent {
			break
		}
	}

}

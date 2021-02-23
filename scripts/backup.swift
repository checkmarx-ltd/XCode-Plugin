#!/usr/bin/swift

import Foundation

struct ShellResult {
	let output: String
	let status: Int32
}

print("Starting Test\n\n")

let pipe = Pipe()
let task = Process()
task.launchPath = "/usr/bin/java"
task.arguments = ["-version"]
// The pipe will be used to read input to a buffer
task.standardOutput = pipe
let outputHandler = pipe.fileHandleForReading
//outputHandler.waitForDataInBackgroundAndNotify()


// This will allow us to capture the buffer in real time
var output = ""
var dataObserver: NSObjectProtocol!
let notificationCenter = NotificationCenter.default
let dataNotificationName = NSNotification.Name.NSFileHandleDataAvailable
dataObserver = notificationCenter.addObserver(forName: dataNotificationName, object: outputHandler, queue: nil)
{
	notification in
    print("Got Line\n")
	let data = outputHandler.availableData
	guard data.count > 0 else {
        print("Count great the 0?\n")
		// notificationCenter.removeObserver(dataObserver)
		return
	}
	if let line = String(data: data, encoding: .utf8) {
		//if isVerbose {
		print("Got Line\n")
        print(line)
		//}
		//output = output + line + "\n"
	}
	outputHandler.waitForDataInBackgroundAndNotify()
}


// Now, we kick off the process and we're running/task.launch()
task.launch()
task.waitUntilExit()

// let data = pipe.fileHandleForReading.readDataToEndOfFile()
// let output = String(data: data, encoding: .utf8) ?? ""
print(output)

print("Done with Test:")

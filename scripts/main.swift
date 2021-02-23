#!/usr/bin/swift

import Foundation

print("Starting Test\n\n")

let pipe = Pipe()
let task = Process()
task.standardOutput = pipe
task.launchPath = "/usr/bin/java"
task.arguments = ["-jar",
                  "/Users/jeffarmstrong/cxflow/cxflow.jar",
                  "--scan",
                  "--checkmarx.base-url=\"http://somedomain\"",
                  "--checkmarx.username=\"xxxxxxxx\"",
                  "--checkmarx.password=\"XXXXXXXXXX\"",
                  "--checkmarx.multi-tenant=false",
                  "--checkmarx.incremental=false",
                  "--checkmarx.scan-preset=\"Checkmarx Default\"",
                  "--checkmarx.team=\"XXXXX\"",
                  "--json.data-folder=\"XXXXX\"",
                  "--cx-project=\"goatD\"",
                  "--app=\"xCodeApp\"",
                  "--f=\"XXXXXX\""]


// Now, we kick off the process and we're running/task.launch()
task.launch()
task.waitUntilExit()


//let outputHandler = pipe.fileHandleForReading
//let data = outputHandler.readDataToEndOfFile()
//let output = String(data: data, encoding: String.Encoding.utf8)
let output = pipe.fileHandleForReading.readDataToEndOfFile().base64EncodedString()
print(output)

// print(output)

print("\n\nDone with Test")

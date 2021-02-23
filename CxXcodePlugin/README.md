#####  <#Title#>

The code favors sending options on the CLI then through the YAML file.

- Results are cached for pulling up previous work


1. Running CxFlow and store result
2. Decode the Result
3. Display the Result in a tree
4. Make Sure Core data saves state
---
5. Work on Result display



// Sample CxFlow run
java -jar cxflow.jar \
            --scan \
            --username="jarmstrong"
            --password=""
            --multi-tenant=true
            --incremental=false
            --scan-preset="Checkmarx Default"
            --team="\CxServer\SP\Company\Users\tsunez" \
            --cx-project="goat" \
            --app="xCodeApp" \
            --f="goat"


1. 
Can I enumerate the teams
Can I enumerate the presets


Need options to configure filters
Need an option to configure where the logs go

    /cxflow/results/<project-name>




##### Status Messages to Track
---

// This will be generated periodically as long as the scan is running
// If it takes longer the then 'timeout' then you know something happened.
waitForScanCompletion() checking status....
waitForScanCompletion() checking status. Status code: [10], runtime: [20000]

codes
 10 -
   3 - 
   4 - Working
   7 - When project was finished scanning
  


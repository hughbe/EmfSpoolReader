# EmfSpoolReader

Swift definitions for structures, enumerations and functions defined in [MS-EMFSPOOL](https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-emfspool/)

## Example Usage

Add the following line to your project's SwiftPM dependencies:
```swift
.package(url: "https://github.com/hughbe/EmfSpoolReader", from: "1.0.0"),
```

```swift
import EmfSpoolReader

let data = Data(contentsOfFile: "<path-to-file>.SPL")!
let file = try EmfSpoolFile(data: data)
try file.enumerateRecords { record in
    print("Record: \(record)")
    return .continue
}
```

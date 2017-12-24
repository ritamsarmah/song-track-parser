# TrackParser
Parses a list of track information for an album entered in any text format. Outputs result as comma-separated values and allows export to disk as a CSV file. Uses NSRegularExpression to parse input.

<img src="https://github.com/ritamsarmah/track-parser/raw/master/TrackParser/Assets.xcassets/AppIcon.appiconset/Icon-128.png">

## Demo
<img src="https://github.com/ritamsarmah/track-parser/raw/master/demo.gif" height="400">

## Usage
1. Type or paste in track info
2. Enter line format including the following tags
    - Required:
        - Track Title: `TITLE`
        - Time/Length: `TIME`
    - Optional:
        - Track Number: `NUM`
        - Artist Name: `ARTIST`
3. Select checkboxes of desired fields in output
4. Click "Parse Info"

## Exporting to CSV
1. Go to "File" > "Export..."
2. Select destination & filename
3. Save CSV file
4. Open in spreadsheet or text editor

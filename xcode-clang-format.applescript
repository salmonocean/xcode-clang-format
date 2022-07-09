#!/usr/bin/osascript

on current_document()
	tell application "Xcode"
		set _window_name to name of front window
		repeat with _document in source documents
			if _window_name contains name of _document then
				return _document
			end if
		end repeat
		
		return null
	end tell
end current_document

on has_selected_content(doc)
	tell application "Xcode"
		set range to selected character range of doc
		
		if range is {} then
			return false
		end if
		
		set range_start to (item 1 of range)
		set range_end to (item 2 of range)
		
		if range_start > range_end then
			return false
		end if
		
		return true
	end tell
end has_selected_content

tell application "Xcode"
	set current_doc to my current_document()
	set has_selected to my has_selected_content(current_doc)
	
	if has_selected is true then
		set paragraph_list to (selected paragraph range of current_doc)
		set range_start to (item 1 of paragraph_list)
		set range_end to (item 2 of paragraph_list)
	else
		set range_start to 1
		set range_end to (get length of paragraphs of (get text of current_doc))
	end if
	
	set current_path to (get path of current_doc)
	
	try
		do shell script "export PATH=$PATH:/usr/local/bin; clang-format -i -lines=" & range_start & ":" & range_end & " " & (quoted form of current_path)
	on error error_msg
		display alert "clang-format failed" message error_msg
		return
	end try
end tell

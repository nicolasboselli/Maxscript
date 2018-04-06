global StructuredStorage = dotnet.loadassembly @"C:\Users\Visiolab\Desktop\StructuredStorage_V10.2_binaries\64\CalumMcLellan.StructuredStorage.dll"
-- read properties
(
-- 	file = @"T:\BPD Marignan\Stjacques_de_la_landes_0318\Perspective\Scenes 3d\modelisation\stJacques.modelisation.002.max"
	file = maxFilePath + maxFileName
-- 	file = @"C:\Temp\attr_test01.max"
	PropertySets = dotnetobject "CalumMcLellan.StructuredStorage.PropertySets" file on -- ON is for read only
	member = dotnetclass "CalumMcLellan.StructuredStorage.PropertySetIds"
-- 	format "Summary:\n"
	/*
	if PropertySets.Contains member.SummaryInformation do
	(
		SummaryInfoIds = dotnetclass "CalumMcLellan.StructuredStorage.SummaryInfoIds"
		pp = PropertySets.item[member.SummaryInformation]

		title = pp.item[SummaryInfoIds.Title]
		format "\t%: %\n" title.name title.value
		subject = pp.item[SummaryInfoIds.Subject]
		format "\t%: %\n" subject.name subject.value
		author = pp.item[SummaryInfoIds.Author]
		format "\t%: %\n" author.name author.value
	)
	*/
	
	format "Custom:\n"
	if PropertySets.Contains member.UserDefinedProperties do
	(
		pp = PropertySets.item[member.UserDefinedProperties]
		enum = pp.GetEnumerator()
-- 		format "enum: %\n" enum
		enum.MoveNext()
		while enum.current != undefined do
		(
			if enum.current.name == "RailClone_Inside" then format "\t%: %\n" enum.current.name enum.current.value
-- 			format "\t%: %\n" enum.current.name enum.current.value
			enum.MoveNext()
		)
-- 		enum.Dispose()
	)
-- 	PropertySets.Dispose()
)
-- maxFilePath + maxFileName


-- write properties
/*
(
	file = @"C:\Temp\attr_test.max"
	PropertySets = dotnetobject "CalumMcLellan.StructuredStorage.PropertySets" file off -- OFF is not read only
	member = dotnetclass "CalumMcLellan.StructuredStorage.PropertySetIds"
	format "Summary:\n"
	if PropertySets.Contains member.SummaryInformation do
	(
		SummaryInfoIds = dotnetclass "CalumMcLellan.StructuredStorage.SummaryInfoIds"
		pp = PropertySets.item[member.SummaryInformation]

		title = pp.item[SummaryInfoIds.Title]
		title.value = "changed"
		format "\t%: %\n" title.name title.value
	)
	PropertySets.Dispose()
)
*/
void main(MultiBuild::Workspace& workspace) {
	project_pcre2(workspace, 8);
	project_pcre2(workspace, 16);
	project_pcre2(workspace, 32);
}

void project_pcre2(MultiBuild::Workspace& workspace, const int32 width) {
	auto project = workspace.create_project(".");
	auto properties = project.properties();

	project.name(MultiEngine::format("pcre2-{}", width));
	properties.binary_object_kind(MultiBuild::BinaryObjectKind::eStaticLib);
	project.license("./LICENCE.md");

	project.include_own_required_includes(true);
	project.add_required_project_include({
		"./include"
	});

	properties.files({
		"./include/*.h",

		"./src/pcre2_auto_possess.c",
  		"./gen_src/pcre2_chartables.c",
		"./src/pcre2_chkdint.c",
		"./src/pcre2_compile.c",
		"./src/pcre2_compile_cgroup.c",
		"./src/pcre2_compile_class.c",
		"./src/pcre2_config.c",
		"./src/pcre2_context.c",
		"./src/pcre2_convert.c",
		"./src/pcre2_dfa_match.c",
		"./src/pcre2_error.c",
		"./src/pcre2_extuni.c",
		"./src/pcre2_find_bracket.c",
		"./src/pcre2_jit_compile.c",
		"./src/pcre2_maketables.c",
		"./src/pcre2_match.c",
		"./src/pcre2_match_data.c",
		"./src/pcre2_match_next.c",
		"./src/pcre2_newline.c",
		"./src/pcre2_ord2utf.c",
		"./src/pcre2_pattern_info.c",
		"./src/pcre2_script_run.c",
		"./src/pcre2_serialize.c",
		"./src/pcre2_string_utils.c",
		"./src/pcre2_study.c",
		"./src/pcre2_substitute.c",
		"./src/pcre2_substring.c",
		"./src/pcre2_tables.c",
		"./src/pcre2_ucd.c",
		"./src/pcre2_valid_utf.c",
		"./src/pcre2_xclass.c"
	});

	properties.include_directories("./src");

	properties.defines({
		"PCRE2_STATIC",
		MultiEngine::format("PCRE2_CODE_UNIT_WIDTH={}", width),

		"SUPPORT_UNICODE=1",

		"PCRE2_EXPORT",
		
		// Note: larger allows for larger/more complex regexes
		"LINK_SIZE=2",

		"HEAP_LIMIT=20000000",
		"MATCH_LIMIT=10000000",
		"MATCH_LIMIT_DEPTH=MATCH_LIMIT",
		"MAX_VARLOOKBEHIND=255",
		"NEWLINE_DEFAULT=2",
		"PARENS_NEST_LIMIT=250",
		"PCRE2GREP_BUFSIZE=20480",
		"PCRE2GREP_MAX_BUFSIZE=1048576",
		"MAX_NAME_SIZE=128",
		"MAX_NAME_COUNT=10000"
	});

	{
		MultiBuild::ScopedFilter _(project, "config.platform:Windows");
		properties.defines("HAVE_WINDOWS_H");
	}

	{
		MultiBuild::ScopedFilter _(project, "project.compiler:VisualCpp");
		properties.disable_warnings("4267");
	}
}
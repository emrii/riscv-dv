/*
 * Copyright 2018 Google LLC
 * Copyright 2021 Coverify Systems Technology
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

module riscv.gen.riscv_defines;

public import riscv.gen.riscv_instr_pkg: riscv_instr_name_t, riscv_instr_group_t,
  riscv_instr_category_t, riscv_instr_format_t, va_variant_t, imm_t;

mixin(declareEnums!riscv_instr_name_t());
mixin(declareEnums!riscv_instr_group_t());
mixin(declareEnums!riscv_instr_category_t());
mixin(declareEnums!riscv_instr_format_t());
mixin(declareEnums!va_variant_t());
mixin(declareEnums!imm_t());


public import riscv.gen.isa.riscv_instr: riscv_instr;
public import riscv.gen.isa.riscv_floating_point_instr: riscv_floating_point_instr;
public import riscv.gen.isa.riscv_compressed_instr: riscv_compressed_instr;
public import riscv.gen.isa.riscv_amo_instr: riscv_amo_instr;
public import riscv.gen.isa.riscv_b_instr: riscv_b_instr;
public import riscv.gen.isa.riscv_vector_instr: riscv_vector_instr;
public import riscv.gen.isa.custom.riscv_custom_instr: riscv_custom_instr;

// enum aliases

static string declareEnums (alias E)()
{
  import std.traits;
  import std.conv;
  string res;

  foreach(e; __traits(allMembers, E))
    {
      res ~= "enum " ~ E.stringof ~ " " ~ e ~ " = " ~
	E.stringof ~ "." ~ e ~ ";\n";
    }
  return res;
}

string riscv_instr_mixin_tmpl(BASE_TYPE)(riscv_instr_name_t instr_name,
					 riscv_instr_format_t instr_format,
					 riscv_instr_category_t instr_category,
					 riscv_instr_group_t instr_group,
					 imm_t imm_tp = imm_t.IMM) {
  import std.conv: to;
  string class_str = "class riscv_" ~ instr_name.to!string() ~ "_instr: " ~ BASE_TYPE.stringof;
  class_str ~= "\n{\n";
  class_str ~= "  enum riscv_instr_name_t RISCV_INSTR_NAME_T = \n";
  class_str ~= "       riscv_instr_name_t." ~ instr_name.to!string() ~ ";\n";
  class_str ~= "  mixin uvm_object_utils;\n";
  class_str ~= "  this(string name = \"\") {\n";
  class_str ~= "    super(name);\n";
  class_str ~= "    this.instr_name = riscv_instr_name_t." ~ instr_name.to!string() ~ ";\n";
  class_str ~= "    this.instr_format = riscv_instr_format_t." ~ instr_format.to!string() ~ ";\n";
  class_str ~= "    this.group = riscv_instr_group_t." ~ instr_group.to!string() ~ ";\n";
  class_str ~= "    this.category = riscv_instr_category_t." ~ instr_category.to!string() ~ ";\n";
  class_str ~= "    this.imm_type = imm_t." ~ imm_tp.to!string() ~ ";\n";
  class_str ~= "    set_imm_len();\n";
  class_str ~= "    set_rand_mode();\n";
  class_str ~= "  }\n";
  class_str ~= "}\n";
  return class_str;
}

string riscv_va_instr_mixin_tmpl(BASE_TYPE)(riscv_instr_name_t instr_name,
					    riscv_instr_format_t instr_format,
					    riscv_instr_category_t instr_category,
					    riscv_instr_group_t instr_group,
					    va_variant_t[] vavs = [],
					    string ext = "") {
  import std.conv: to;
  string class_str = "class riscv_" ~ instr_name.to!string() ~ "_instr: " ~ BASE_TYPE.stringof;
  class_str ~= "\n{\n";
  class_str ~= "  enum riscv_instr_name_t RISCV_INSTR_NAME_T = \n";
  class_str ~= "       riscv_instr_name_t." ~ instr_name.to!string() ~ ";\n";
  class_str ~= "  mixin uvm_object_utils;\n";
  class_str ~= "  this(string name = \"\") {\n";
  class_str ~= "    super(name);\n";
  class_str ~= "    this.instr_name = riscv_instr_name_t." ~ instr_name.to!string() ~ ";\n";
  class_str ~= "    this.instr_format = riscv_instr_format_t." ~ instr_format.to!string() ~ ";\n";
  class_str ~= "    this.group = riscv_instr_group_t." ~ instr_group.to!string() ~ ";\n";
  class_str ~= "    this.category = riscv_instr_category_t." ~ instr_category.to!string() ~ ";\n";
  class_str ~= "    this.imm_type = imm_t.IMM;\n";
  class_str ~= "    this.allowed_va_variants = [";
  foreach (vav; vavs) {
    class_str ~= "       va_variant_t." ~ vav.to!string() ~ ",\n";
  }
  class_str ~= "    ];\n";
  class_str ~= "    this.sub_extension = \"" ~ ext ~ "\";\n";
  class_str ~= "    set_imm_len();\n";
  class_str ~= "    set_rand_mode();\n";
  class_str ~= "  }\n";
  class_str ~= "}\n";
  return class_str;
}

class RISCV_INSTR_TMPL(riscv_instr_name_t instr_n,
		       riscv_instr_format_t instr_format,
		       riscv_instr_category_t instr_category,
		       riscv_instr_group_t instr_group,
		       imm_t imm_tp,
		       BASE_TYPE): BASE_TYPE
{
  enum riscv_instr_name_t RISCV_INSTR_NAME_T = instr_n;
  mixin uvm_object_utils;
  this(string name="") {
    super(name);
    this.instr_name = instr_n;
    this.instr_format = instr_format;
    this.group = instr_group;
    this.category = instr_category;
    this.imm_type = imm_tp;
    set_imm_len();
    set_rand_mode();
  }
}

class RISCV_VA_INSTR_TMPL(riscv_instr_name_t instr_n,
			  riscv_instr_format_t instr_format,
			  riscv_instr_category_t instr_category,
			  riscv_instr_group_t instr_group,
			  imm_t imm_tp,
			  BASE_TYPE,
			  string ext,
			  vav...): BASE_TYPE
{
  enum riscv_instr_name_t RISCV_INSTR_NAME_T = instr_n;
  mixin uvm_object_utils;
  this(string name="") {
    super(name);
    this.instr_name = instr_n;
    this.instr_format = instr_format;
    this.group = instr_group;
    this.category = instr_category;
    this.imm_type = imm_tp;
    this.allowed_va_variants = [vav];
    this.sub_extension = ext;
    set_imm_len();
    set_rand_mode();
  }
}

alias riscv_instr_mixin = riscv_instr_mixin_tmpl!riscv_instr;

alias RISCV_INSTR(riscv_instr_name_t instr_n, riscv_instr_format_t instr_format,
		  riscv_instr_category_t instr_category, riscv_instr_group_t instr_group,
		  imm_t imm_tp = imm_t.IMM) =
  RISCV_INSTR_TMPL!(instr_n, instr_format, instr_category, instr_group, imm_tp,
		    riscv_instr);

alias riscv_fp_instr_mixin = riscv_instr_mixin_tmpl!riscv_floating_point_instr;

alias RISCV_FP_INSTR(riscv_instr_name_t instr_n, riscv_instr_format_t instr_format,
		     riscv_instr_category_t instr_category, riscv_instr_group_t instr_group,
		     imm_t imm_tp = imm_t.IMM) =
  RISCV_INSTR_TMPL!(instr_n, instr_format, instr_category, instr_group, imm_tp,
		    riscv_floating_point_instr);

alias riscv_amo_instr_mixin = riscv_instr_mixin_tmpl!riscv_amo_instr;

alias RISCV_AMO_INSTR(riscv_instr_name_t instr_n, riscv_instr_format_t instr_format,
		      riscv_instr_category_t instr_category, riscv_instr_group_t instr_group,
		      imm_t imm_tp = imm_t.IMM) =
  RISCV_INSTR_TMPL!(instr_n, instr_format, instr_category, instr_group, imm_tp,
		    riscv_amo_instr);

alias riscv_c_instr_mixin = riscv_instr_mixin_tmpl!riscv_compressed_instr;

alias RISCV_C_INSTR(riscv_instr_name_t instr_n, riscv_instr_format_t instr_format,
		    riscv_instr_category_t instr_category, riscv_instr_group_t instr_group,
		    imm_t imm_tp = imm_t.IMM) =
  RISCV_INSTR_TMPL!(instr_n, instr_format, instr_category, instr_group, imm_tp,
		    riscv_compressed_instr);

alias riscv_fc_instr_mixin = riscv_instr_mixin_tmpl!riscv_compressed_instr;

alias RISCV_FC_INSTR(riscv_instr_name_t instr_n, riscv_instr_format_t instr_format,
		     riscv_instr_category_t instr_category, riscv_instr_group_t instr_group,
		     imm_t imm_tp = imm_t.IMM) =
  RISCV_INSTR_TMPL!(instr_n, instr_format, instr_category, instr_group, imm_tp,
		    riscv_compressed_instr);

alias riscv_va_instr_mixin = riscv_va_instr_mixin_tmpl!riscv_vector_instr;

alias RISCV_VA_INSTR(riscv_instr_name_t instr_n, riscv_instr_format_t instr_format,
		     riscv_instr_category_t instr_category, riscv_instr_group_t instr_group,
		     string ext, vav...) =
  RISCV_VA_INSTR_TMPL!(instr_n, instr_format, instr_category, instr_group, imm_t.IMM,
		       riscv_vector_instr, ext, vav);

alias riscv_custom_instr_mixin = riscv_instr_mixin_tmpl!riscv_custom_instr;

alias RISCV_CUSTOM_INSTR(riscv_instr_name_t instr_n, riscv_instr_format_t instr_format,
			 riscv_instr_category_t instr_category, riscv_instr_group_t instr_group,
			 imm_t imm_tp = imm_t.IMM) =
  RISCV_INSTR_TMPL!(instr_n, instr_format, instr_category, instr_group, imm_tp,
		    riscv_custom_instr);

alias riscv_b_instr_mixin = riscv_instr_mixin_tmpl!riscv_b_instr;

alias RISCV_B_INSTR(riscv_instr_name_t instr_n, riscv_instr_format_t instr_format,
		    riscv_instr_category_t instr_category, riscv_instr_group_t instr_group,
		    imm_t imm_tp = imm_t.IMM) =
  RISCV_INSTR_TMPL!(instr_n, instr_format, instr_category, instr_group, imm_tp,
		    riscv_b_instr);


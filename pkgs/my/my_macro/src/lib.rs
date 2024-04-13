extern crate proc_macro;
use proc_macro::TokenStream;
use heck::ToUpperCamelCase;

struct ShellDesc {
    short_name: String,
    camel_case_name: String,
}

impl From<&str> for ShellDesc {
    fn from(text: &str) -> ShellDesc {
        ShellDesc {
            short_name: String::from(text),
            camel_case_name: text.to_upper_camel_case()
        }
    }
}

/// Get shells from TOML file
#[proc_macro]
pub fn get_shells(_: TokenStream) -> TokenStream {

    // TEMP
    let shells_list = vec!["fake-sh", "other-sh"];
    let shells: Vec<ShellDesc> = shells_list.iter().collect();
    "fn answer() -> u32 { 42 }".parse().unwrap()
}

#[proc_macro]
pub fn get_machines(_: TokenStream) -> TokenStream {

    // TEMP
    let home_manager_machines = vec!["work", "work-server"];
    let hm_names = home_manager_machines.iter().map(|m| m.to_upper_camel_case()).collect::<Vec<String>>();


    let mut out = String::new();

    // Define Machines enum
    out.push_str("pub enum Machines {\n");
    for machine in &hm_names {
        out.push_str(&format!("    {},\n", machine));
    }
    out.push_str("}\n\n");

    // Implement Machines into Configuration
    out.push_str("impl From<Machines> for Configuration {\n");
    out.push_str("    fn from(machine: Machines) -> Self {\n");
    out.push_str("        match machine {\n");
    for machine in &hm_names {
        out.push_str(&format!("            Machines::{} => Configuration {{ name: {}, config_type: ConfigurationType::HomeManager }},\n", machine, machine));
    }
    out.push_str("        }\n");
    out.push_str("    }\n");
    out.push_str("}\n\n");

    for machine in &home_manager_machines {
        out.push_str(&format!("pub const {}: &str = \"{}\";\n", machine.to_uppercase(), machine));
    }

    "fn answer() -> u32 { 42 }".parse().unwrap()
}

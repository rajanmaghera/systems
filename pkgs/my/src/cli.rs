use clap::{Parser, Subcommand};

/// Rajan's command line tool
#[derive(Parser, Debug)]
#[command(author, version, about, long_about=None)]
pub struct Args {
    #[command(subcommand)]
    pub command: Commands,
}

pub enum ConfigurationType {
    HomeManager,
    NixOS,
    NixDarwin,
}

pub struct Configuration {
    pub name: &'static str,
    pub config_type: ConfigurationType,
}

// Populate machines from TOML file
// at compile time, if available.
// get_machines!();

// Populate shells from TOML file,
// if available.
// get_shells!();

#[derive(Subcommand, Debug)]
pub enum ShellConfig {
    #[command(name="cuda_shell", about="CUDA Shellsss")]
    CudaSh,
    RustSh
}

impl ShellConfig {
    pub fn to_cmd(&self) -> &[&str; 2] {
        match self {
            ShellConfig::CudaSh => &["develop", "/home/rajan/systems#cuda-shell"],
            ShellConfig::RustSh => &["develop", "/home/rajan/systems#rust-shell"],
        }
    }
}

#[derive(Subcommand, Debug)]
pub enum Commands {
    /// Switch to this home manager config
    SwitchHm {
        /// The name of the home manager config
        name: String,
    },
    Shell {

        #[command(subcommand)]
        config: ShellConfig,

    }
}

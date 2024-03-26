use clap::{Command, CommandFactory};
use clap_complete::{
    generate_to,
    shells::{Bash, Fish, Zsh},
    Generator,
};
use std::env;
use std::ffi::OsString;
use std::io::Error;

include!("src/cli.rs");

fn generate_for_shell(
    gen: impl Generator,
    cmd: &mut Command,
    out_dir: impl Into<OsString>,
) -> Result<(), Error> {
    let path = generate_to(gen, cmd, "mycmd", out_dir)?;
    println!("cargo:warning=Generated completion file at {path:?}");
    Ok(())
}

fn main() -> Result<(), Error> {
    let out_dir = env::var_os("OUT_DIR").expect("OUT_DIR not set");
    let mut cmd = Args::command();

    generate_for_shell(Bash, &mut cmd, &out_dir)?;
    generate_for_shell(Fish, &mut cmd, &out_dir)?;
    generate_for_shell(Zsh, &mut cmd, &out_dir)?;

    Ok(())
}

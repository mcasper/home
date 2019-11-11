use tera::Tera;

pub static TERA: Tera = {
    let mut tera = compile_templates!("templates/**/*");
    tera
};

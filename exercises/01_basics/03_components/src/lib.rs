#[allow(warnings)]
mod bindings;

struct Example;

impl bindings::Guest for Example {
    fn add_random(a: u64) -> u64 {
        let b = bindings::wasi::random::random::get_random_u64();

        a + b
    }
}

bindings::export!(Example with_types_in bindings);

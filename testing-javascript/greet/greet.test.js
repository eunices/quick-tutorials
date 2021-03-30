const greet = require('./greet');

test('Test that greet returns Welcome, <name>', () => {
    expect(greet('Bob')).toBe('Hello, Bob.');
})

test('Test that greet returns Welcome, my friend. if name is null', () => {
    expect(greet(null)).toBe('Hello, my friend.');
})
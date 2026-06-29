module.exports = {
  root: true,
  env: {
    es2020: true,
    jest: true,
    node: true,
  },
  extends: ["eslint:recommended"],
  parserOptions: {
    ecmaVersion: 2020,
    sourceType: "script",
  },
  ignorePatterns: [
    "node_modules/",
    "dist/",
    "old/",
    ".eslintrc*.js",
  ],
  rules: {
    "no-unused-vars": "off",
  },
};

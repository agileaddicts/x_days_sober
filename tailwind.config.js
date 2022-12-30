/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./assets/js/**/*.js", "./lib/*_web.ex", "./lib/*_web/**/*.*ex"],
  theme: {
    extend: {},
    colors: {
      'ruby': '#D81E5B',
      'prussian-blue': '#102E4A',
      'cadet-blue': '#5AB1BB',
      'canary': '#FFFD98',
      'floral-white': '#FFF8F0'
    },
  },
  plugins: [],
}

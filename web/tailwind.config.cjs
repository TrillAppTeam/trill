/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      fontFamily: {
        'body': 'Source Sans Pro'
      },
      fontWeight: {
        'bold': 900,
      },
      colors: {
        'trillPurple': '#1A1B29',
        'trillBlue': '#3FBCF4',
        'white': '#FFFFFF',
      },
    },
  },
  plugins: [],
}

import { useEffect, useState } from 'react'
import axios from 'axios'
import './App.css'

const api = axios.create({ baseURL: 'http://127.0.0.1:8000/api' })

function App() {
  const [products, setProducts] = useState([])

  useEffect(() => {
    api.get('/products')
      .then((response) => setProducts(response.data))
      .catch((error) => console.error(error))
  }, [])

  return (
    <main className="app-shell">
      <section className="hero-card">
        <p className="eyebrow">Vendor portal</p>
        <h1>Vendor Web Experience</h1>
        <p>React 18 + Vite app consuming the shared Laravel API.</p>
      </section>

      <section className="panel">
        <h2>Inventory overview</h2>
        <ul>
          {products.map((product) => (
            <li key={product.id}>
              <strong>{product.name}</strong> — Stock: {product.stock}
            </li>
          ))}
        </ul>
      </section>
    </main>
  )
}

export default App

import { useEffect, useState } from 'react'
import axios from 'axios'
import './App.css'

const api = axios.create({ baseURL: 'http://127.0.0.1:8000/api' })

function App() {
  const [status, setStatus] = useState('Checking API...')
  const [products, setProducts] = useState([])

  useEffect(() => {
    const loadData = async () => {
      try {
        const healthResponse = await api.get('/health')
        setStatus(healthResponse.data.status)

        const productsResponse = await api.get('/products')
        setProducts(productsResponse.data)
      } catch (error) {
        setStatus('API unavailable')
        console.error(error)
      }
    }

    loadData()
  }, [])

  return (
    <main className="app-shell">
      <section className="hero-card">
        <p className="eyebrow">Hybrid commerce platform</p>
        <h1>Admin Web Portal</h1>
        <p>React 18 + Vite frontend connected to Laravel 11 API.</p>
        <div className="pill">API status: {status}</div>
      </section>

      <section className="panel">
        <h2>Shared products</h2>
        {products.length === 0 ? (
          <p>No products yet. Seed the API or add one from the Laravel backend.</p>
        ) : (
          <ul>
            {products.map((product) => (
              <li key={product.id}>
                <strong>{product.name}</strong> — {product.description} <br />
                Price: {product.price} | Stock: {product.stock}
              </li>
            ))}
          </ul>
        )}
      </section>
    </main>
  )
}

export default App

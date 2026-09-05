import { useEffect, useState } from 'react'
import axios from 'axios'

interface HealthResponse {
  status: string
}

interface Product {
  id: number | string
  name: string
  description: string | null
  price: number | string
  stock: number
}

const api = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL ?? 'http://127.0.0.1:8080/api/v1',
})

function App() {
  const [status, setStatus] = useState('Checking API...')
  const [products, setProducts] = useState<Product[]>([])

  useEffect(() => {
    const loadData = async () => {
      try {
        const healthResponse = await api.get<HealthResponse>('/health')
        setStatus(healthResponse.data.status)

        const productsResponse = await api.get<Product[]>('/products')
        setProducts(productsResponse.data)
      } catch (error) {
        setStatus('API unavailable')
        console.error(error)
      }
    }

    loadData()
  }, [])

  return (
    <main className="min-h-screen bg-surface-canvas px-6 py-8 text-text-strong md:px-8">
      <section className="mx-auto max-w-5xl border-b border-border-default py-8">
        <p className="mb-3 text-label font-semibold text-brand-orange-600">Platform operations</p>
        <h1 className="text-h1 font-bold">Admin Web Portal</h1>
        <p className="mt-3 text-body text-text-secondary">
          React 19, strict TypeScript, Vite 8, and Tailwind CSS connected to the Laravel 13 API.
        </p>
        <p className="mt-4 inline-flex min-h-11 items-center rounded-control bg-brand-orange-50 px-3 text-body-strong">
          API status: {status}
        </p>
      </section>

      <section className="mx-auto max-w-5xl py-8">
        <h2 className="text-h2 font-bold">Shared products</h2>
        {products.length === 0 ? (
          <p className="mt-4 text-body text-text-secondary">
            No products yet. Seed the API or add one from the Laravel backend.
          </p>
        ) : (
          <ul className="mt-4 divide-y divide-border-default">
            {products.map((product) => (
              <li className="py-3 text-body" key={product.id}>
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

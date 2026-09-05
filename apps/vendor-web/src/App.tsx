import { useEffect, useState } from 'react'
import axios from 'axios'

interface Product {
  id: number | string
  name: string
  stock: number
}

const api = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL ?? 'http://127.0.0.1:8080/api/v1',
})

function App() {
  const [products, setProducts] = useState<Product[]>([])

  useEffect(() => {
    api.get<Product[]>('/products')
      .then((response) => setProducts(response.data))
      .catch((error) => console.error(error))
  }, [])

  return (
    <main className="min-h-screen bg-surface-canvas px-6 py-8 text-text-strong md:px-8">
      <section className="mx-auto max-w-5xl border-b border-border-default py-8">
        <p className="mb-3 text-label font-semibold text-brand-orange-600">Vendor portal</p>
        <h1 className="text-h1 font-bold">Vendor Web Experience</h1>
        <p className="mt-3 text-body text-text-secondary">
          React 19, strict TypeScript, Vite 8, and Tailwind CSS consuming the shared Laravel 13 API.
        </p>
      </section>

      <section className="mx-auto max-w-5xl py-8">
        <h2 className="text-h2 font-bold">Inventory overview</h2>
        <ul className="mt-4 divide-y divide-border-default">
          {products.map((product) => (
            <li className="py-3 text-body" key={product.id}>
              <strong>{product.name}</strong> — Stock: {product.stock}
            </li>
          ))}
        </ul>
      </section>
    </main>
  )
}

export default App

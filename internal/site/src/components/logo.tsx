import { useId } from "react"

export function Logo({ className }: { className?: string }) {
	const id = useId()

	return (
		<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 380 48" className={`text-foreground ${className ?? ""}`} role="img" aria-label="Anarchy Pulse">
			<defs>
				<linearGradient id={id} x1="0%" y1="0%" x2="100%" y2="0%">
					<stop offset="0%" stopColor="#e0115f" />
					<stop offset="100%" stopColor="#ff6b8a" />
				</linearGradient>
			</defs>
			<text
				x="50%"
				y="50%"
				dominantBaseline="central"
				textAnchor="middle"
				fill="currentColor"
				className="duration-250 group-hover:opacity-0 group-hover:ease-in ease-out"
				style={{
					fontFamily: "'Share Tech Mono', monospace",
					fontSize: "22px",
					letterSpacing: "0.35em",
				}}
			>
				ANARCHY PULSE
			</text>
			<text
				x="50%"
				y="50%"
				dominantBaseline="central"
				textAnchor="middle"
				fill={`url(#${id})`}
				className="opacity-0 duration-250 group-hover:opacity-100 ease-in-out"
				style={{
					fontFamily: "'Share Tech Mono', monospace",
					fontSize: "22px",
					letterSpacing: "0.35em",
				}}
			>
				ANARCHY PULSE
			</text>
		</svg>
	)
}

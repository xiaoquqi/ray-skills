<template>
  <Transition
    enter-active-class="transition duration-200 ease-out"
    enter-from-class="opacity-0"
    enter-to-class="opacity-100"
    leave-active-class="transition duration-150 ease-in"
    leave-from-class="opacity-100"
    leave-to-class="opacity-0"
  >
    <div
      v-if="show"
      class="dialog-backdrop"
      aria-hidden="true"
      @click="handleOverlayClick"
    />
  </Transition>

  <Transition
    enter-active-class="transition-transform duration-300 ease-out"
    enter-from-class="translate-x-full"
    enter-to-class="translate-x-0"
    leave-active-class="transition-transform duration-250 ease-in"
    leave-from-class="translate-x-0"
    leave-to-class="translate-x-full"
  >
    <div
      v-if="show"
      class="fixed inset-y-0 right-0 w-full z-50 flex flex-col overflow-hidden rounded-l-xl"
      :class="maxWidthClass"
      aria-modal="true"
      role="dialog"
      style="background-color: var(--color-surface-elevated); box-shadow: var(--shadow-soft-lg); border-left: 1px solid var(--color-border);"
      @click.stop
    >
      <div class="dialog-header border-b border-border flex-shrink-0">
        <slot name="header">
          <h2 class="dialog-header-title text-base md:text-lg truncate">
            {{ title }}
          </h2>
        </slot>
        <button
          type="button"
          class="ml-auto dialog-close-btn"
          aria-label="Close"
          @click="emitClose"
        >
          <svg
            class="w-5 h-5"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M6 18L18 6M6 6l12 12"
            />
          </svg>
        </button>
      </div>

      <div class="flex-1 overflow-y-auto min-h-0">
        <slot />
      </div>

      <div
        v-if="$slots.footer"
        class="flex-shrink-0 dialog-footer admin-dialog-actions rounded-none"
      >
        <slot name="footer" />
      </div>
    </div>
  </Transition>
</template>

<script setup>
const props = defineProps({
  show: {
    type: Boolean,
    default: false
  },
  title: {
    type: String,
    default: ''
  },
  maxWidthClass: {
    type: String,
    default: 'md:max-w-2xl'
  },
  closeOnOverlay: {
    type: Boolean,
    default: true
  }
})

const emit = defineEmits(['close'])

function emitClose() {
  emit('close')
}

function handleOverlayClick() {
  if (!props.closeOnOverlay) return
  emitClose()
}
</script>
